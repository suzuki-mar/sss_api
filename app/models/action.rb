class Action < ApplicationRecord

  include Swagger::ActionSchema

  validates :progress_status, presence: true
  validates :due_date, presence: true
  validates :evaluation_method, presence: true
  validates :execution_method, presence: true
  validate :validate_document_id

  enum progress_status:{not_started: 1, doing: 2, done: 3}

  scope :only_doing, -> { where(progress_status: :doing) }
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

end
