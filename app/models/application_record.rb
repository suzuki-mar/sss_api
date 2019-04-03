class ApplicationRecord < ActiveRecord::Base
  include Swagger::GeneralValueObjectSchema

  self.abstract_class = true

  def table_name
    self.class.to_s.underscore.pluralize
  end

  def foreign_key_column
    "#{table_name.singularize}_id"
  end

end
