class TagAssociation < ApplicationRecord

  belongs_to :tag
  belongs_to :problem_solving, optional: true
  belongs_to :reframing, optional: true

  validate :validate_document_id

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
