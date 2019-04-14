class Action < ApplicationRecord

  include SearchFromAllTextColumnModel

  validates :progress_status, presence: true
  validates :due_date, presence: true
  validates :evaluation_method, presence: true
  validates :execution_method, presence: true
  validate :validate_document_id

  enum progress_status:{not_started: 1, doing: 2, done: 3}

  scope :only_doing, -> { where(progress_status: :doing) }
  scope :only_done, -> { where(progress_status: :done) }

  scope :with_related_document, -> do
    eager_load({self_care: [:self_care_classification, {tag_associations: :tag}]})
        .eager_load({reframing: {tag_associations: :tag}})
        .eager_load({problem_solving: {tag_associations: :tag}})
  end


  belongs_to :problem_solving, optional: true
  belongs_to :self_care, optional: true
  belongs_to :reframing, optional: true

  def self.document_id_keys
    instance = self.new
    keys = instance.attributes.keys
    keys.select do |key|
      key.include?('_id')
    end
  end

  def validate_document_id
    association_keys = self.class.document_id_keys.select do |key|
      self[key].present?
    end

    if association_keys.count == 0
      errors.add(:document_id, '作成物に一つも関連付けられていません')
    end

    if association_keys.count >= 2
      errors.add(:document_id, '作成物に複数関連付けられています')
    end

  end

  def set_document(document)
    self[document.foreign_key_column] = document.id
  end
  
  def document
    # 下のだとN+1になってしまうケースがある
    # self.problem_solving || self.self_care || self.reframing

    document_id_column = self.class.document_id_keys.find do |key|
      self[key].present?
    end

    model_name = document_id_column.gsub('_id', '')
    self.send(model_name)

  end

  def self.find_ids_by_tag_name(tag_name)

    grouped_document_ids = TagAssociation.find_grouped_document_ids_by_tag_name_and_id_keys(tag_name, self.document_id_keys)
    grouped_parent_ids = {}

    grouped_document_ids.each do |forein_key_column, ids|
      next unless ids.present?

      parent_name = forein_key_column.gsub("_id", "")
      grouped_parent_ids[parent_name] = ids
    end

    self.find_ids_by_grouped_parent_ids(grouped_parent_ids)
  end

  def self.find_ids_by_parent_text(search_target_text)

    grouped_parent_ids = {}
    self.document_id_keys.each do |document_id_key|
      table_name = document_id_key.gsub('_id', '')
      model_class = table_name.camelize.constantize
      grouped_parent_ids[table_name] = model_class.search_from_all_text_column(search_target_text).pluck(:id)
    end

    self.find_ids_by_grouped_parent_ids(grouped_parent_ids)
  end

  def self.find_ids_by_text(search_target_text)
    self.search_from_all_text_column(search_target_text).pluck(:id)
  end

  private
  def self.find_ids_by_grouped_parent_ids(grouped_parent_ids)
    # TODO SQLをチューニングする
    ids = grouped_parent_ids.map do |name, parent_ids|
      where_target = "#{name.to_s.pluralize}.id"
      Action.joins(name.to_sym).where("#{where_target}" => parent_ids).pluck(:id)
    end

    ids.flatten
  end

end
