class ApplicationRecord < ActiveRecord::Base
  include Swagger::GeneralValueObjectSchema

  self.abstract_class = true
end
