class TagAssociation < ApplicationRecord

  belongs_to :tag
  belongs_to :problem_solving, optional: true
  belongs_to :reframing, optional: true

  validate :validate_document_id

  class << self
    def create_from_tag_names_and_document_model_if_unexists!(tag_names, document_model)
      tags = Tag.where(name: tag_names)

      exsits_tags = Tag.only_associated(document_model)

      tags.each do |tag|
        next if exsits_tags.include?(tag)

        tag_association = TagAssociation.new
        tag_association.tag = tag

        tag_association[document_model.foreign_key_column] = document_model.id
        tag_association.save!
      end
    end

    def delete_from_tag_names(tag_names)

      delete_tag_ids = TagAssociation.joins(:tag).where('tags.name': tag_names)
      TagAssociation.where(id: delete_tag_ids).destroy_all
    end

  end



  private
  def validate_document_id

    document_id_keys = [:problem_solving_id, :reframing_id]

    association_keys = document_id_keys.select do |key|
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
