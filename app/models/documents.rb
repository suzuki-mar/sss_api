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

    def create_list_by_grouped_document_ids(grouped_document_ids)
      grouped_documents = create_grouped_document_elements_by_grouped_document_ids(grouped_document_ids)

      document_elements_of_grouped_by_date = create_document_elements_of_grouped_by_date(grouped_documents)

      document_elements_of_grouped_by_date.map do |log_date, params|
        Documents.create_log_date_and_params(log_date, params)
      end
    end

    private
    def create_grouped_document_elements_by_grouped_document_ids(grouped_document_ids)
      grouped_documents = {}
      grouped_document_ids.each do |key, ids|
        model_name = key.to_s.gsub(/(.*)(_id)/, '\1').camelize
        model_class = model_name.constantize
        grouped_documents[model_name] = model_class.where(id: ids).with_tags
      end

      grouped_documents
    end

    def create_document_elements_of_grouped_by_date(grouped_documents)
      document_elements_of_grouped_by_date = {}

      grouped_documents.each do |key, elements|
        param_key = key.underscore.pluralize

        elements.each do |element|

          unless document_elements_of_grouped_by_date.has_key?(element.log_date)
            document_elements_of_grouped_by_date[element.log_date] = {}
          end

          unless document_elements_of_grouped_by_date[element.log_date].has_key?(param_key)
            document_elements_of_grouped_by_date[element.log_date][param_key] = []
          end

          document_elements_of_grouped_by_date[element.log_date][param_key] << element
        end

      end

      document_elements_of_grouped_by_date
    end

  end

end