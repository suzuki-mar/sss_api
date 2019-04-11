class Action < ApplicationRecord

  include Swagger::ActionSchema

  validates :progress_status, presence: true
  validates :due_date, presence: true
  validates :evaluation_method, presence: true
  validates :execution_method, presence: true
  validate :validate_document_id

  enum progress_status:{not_started: 1, doing: 2, done: 3}

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

  def set_document_element(document_element)
    self[document_element.foreign_key_column] = document_element.id
  end

end
