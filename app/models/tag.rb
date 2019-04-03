class Tag < ApplicationRecord

  include Swagger::TagSchema
  validates :name, uniqueness: true

  has_many :tag_associations, dependent: :destroy

end