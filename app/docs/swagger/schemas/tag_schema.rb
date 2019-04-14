module Swagger::Schemas::TagSchema

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :TagInput do
      key :required, [:names]

      property :names do
        key :type, :string
        key :description, 'タグ名を,区切りで入力する'
        key :example, 'タグA,タグB'
      end
    end

    swagger_schema :TagOutput do
      key :required, [:name, :id]

      property :name do
        key :type, :string
        key :description, 'タグ名'
        key :example, 'タグA'
      end

      property :id do
        key :type, :integer
        key :description, 'ID'
      end
    end
  end
end