class ApplicationRecord < ActiveRecord::Base
  include Swagger::GeneralValueObjectSchema

  scope :by_ids, -> (ids) { where(id: ids) }

  self.abstract_class = true

  def table_name
    self.class.table_name
  end

  def foreign_key_column
    self.class.foreign_key_column
  end

  def self.table_name
    self.to_s.underscore.pluralize
  end

  def self.foreign_key_column
    "#{table_name.singularize}_id"
  end

end
