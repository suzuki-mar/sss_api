module Swagger::GeneralValueObjectSchema

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_schema :DateValueLineGraphItem do
      key :required, [:date, :value]

      property :date do
        key :type, :string
        key :format, :date
        key :description, '日付'
        key :example, '2019-03-03'
      end

      property :value do
        key :type, :integer
        key :description, '値'
      end

    end
  end
end