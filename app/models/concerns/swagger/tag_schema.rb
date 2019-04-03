module Swagger::TagSchema

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Tag do
      key :required, [:id, :name]

      property :id do
        key :type, :integer
        key :description, 'ID'
      end

      property :name do
        key :type, :string
        key :description, 'タグ名'
        key :example, 'タグA'
      end

    end
  end
end