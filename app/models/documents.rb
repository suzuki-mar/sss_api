class Documents

  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization

  DOCUMENT_TYPES = [:problem_solving, :reframing, :self_care].freeze

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

    def find_by_log_date_and_type(log_date, type, is_includes_related: true)
      raise ArgumentError.new("対応していないtypeが渡されました:#{type}") unless self.valid_type?(type)

      types = type == :all ? DOCUMENT_TYPES : [type]

      params = {}
      types.each do |type|
        model_class = type.to_s.camelize.constantize
        attr_name = type.to_s.pluralize.to_sym

        params[attr_name] = if is_includes_related
                              model_class.where(log_date: log_date).includes_related_items
                            else
                              model_class.where(log_date: log_date)
                            end
      end

      self.create_log_date_and_params(log_date, params)
    end

    def valid_type?(type)
      type == :all || DOCUMENT_TYPES.include?(type)
    end

  end

  def has_type?(type)
    key = type.to_s.pluralize
    self.attributes[key].present?
  end

  def empty?

    DOCUMENT_TYPES.none? do |type|
      self.has_type?(type)
    end

  end
end