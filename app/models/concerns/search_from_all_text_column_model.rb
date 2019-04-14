module SearchFromAllTextColumnModel

  extend ActiveSupport::Concern

  included do
    include SearchCop

    search_scope :search_from_all_text_column do

      column_names = self.model.columns.map do |column|
        next unless column.sql_type_metadata.type == :text
        column.name
      end.compact

      attributes column_names
    end

  end

end