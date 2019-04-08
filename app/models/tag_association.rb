class TagAssociation < ApplicationRecord

  belongs_to :tag
  belongs_to :problem_solving, optional: true
  belongs_to :reframing, optional: true

  validate :validate_document_id

  DOCUMNET_ID_KEYS = [:problem_solving_id, :reframing_id].freeze

  class << self

    def find_grouped_document_ids_by_tag_name_and_target_type(tag_name, target_type)

      document_id_key = "#{target_type}_id"
      find_grouped_document_ids_by_tag_name_and_document_id_keys(tag_name, [document_id_key])
    end

    def find_grouped_document_ids_by_tag_name(tag_name)
      associations = self.includes(:tag).where('tags.name' => tag_name)

      grouped_ids = {}
      DOCUMNET_ID_KEYS.each do |key|
        grouped_ids[key] = []
      end

      associations.each do |association|

       DOCUMNET_ID_KEYS.each do |search_key|
          if association[search_key].present?
            grouped_ids[search_key] << association[search_key]
          end
        end

      end

      grouped_ids
    end

    def create_from_tag_names_text_and_document_model_if_unexists!(tag_names_text, document_model)
      tags = Tag.where(name: tag_names_text)

      exsits_tags = Tag.only_associated(document_model)

      tags.each do |tag|
        next if exsits_tags.include?(tag)

        tag_association = TagAssociation.new
        tag_association.tag = tag

        tag_association[document_model.foreign_key_column] = document_model.id
        tag_association.save!
      end
    end

    def delete_from_tag_names_text(tag_names_text)

      delete_tag_ids = TagAssociation.joins(:tag).where('tags.name': tag_names_text)
      TagAssociation.where(id: delete_tag_ids).destroy_all
    end


    private
    def find_grouped_document_ids_by_tag_name_and_document_id_keys(tag_name, document_id_keys)
      associations = self.includes(:tag).where('tags.name' => tag_name)

      grouped_ids = {}
      document_id_keys.each do |key|
        grouped_ids[key] = []
      end

      associations.each do |association|

        document_id_keys.each do |search_key|
          if association[search_key].present?
            grouped_ids[search_key] << association[search_key]
          end
        end

      end

      grouped_ids
    end

  end



  private
  def validate_document_id

    association_keys = DOCUMNET_ID_KEYS.select do |key|
      self[key].present?
    end

    if association_keys.count == 0
      errors.add(:document_id, '作成物に一つも関連付けられていません')
    end

    if association_keys.count >= 2
      errors.add(:document_id, '作成物に複数関連付けられています')
    end

  end

end
