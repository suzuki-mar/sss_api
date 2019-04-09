class Documents

  include Swagger::DocumentsSchema

  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization

  attribute :problem_solvings
  attribute :reframings
  attribute :self_cares
  attribute :log_date

  class << self
    def create_log_date_and_params(log_date, params)
      documents = self.new
      documents.log_date = log_date
      documents.attributes = params

      documents
    end

  end

  def has_type?(type)
    key = type.to_s.pluralize

    pp self.attributes[key].present?

    self.attributes[key].present?
  end
end