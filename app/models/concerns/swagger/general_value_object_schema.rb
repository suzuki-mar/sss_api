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

    swagger_schema :PieChartItem do
      key :required, [:name, :value, :percentage]

      property :name do
        key :type, :string
        key :description, 'アイテム名'
        key :example, 'アイテム1'
      end

      property :value do
        key :type, :integer
        key :description, '値'
      end

      property :percentage do
        key :type, :integer
        key :description, 'パーセント 11なら11%'
        key :example, '11'
      end

    end

  end
end