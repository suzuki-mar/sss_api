module Swagger::SelfCareSchema

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :SelfCare do
      key :required, [
          :log_date, :am_pm, :reason, :point
      ]
      property :reason do
        key :type, :string
        key :description, '体調の理由'
        key :example, 'ゲームの配信が決まってモチベーションが上がっている'
      end
      property :log_date do
        key :type, :string
        key :format, :date
        key :description, '記録をした日付'
        key :example, '2019-03-03'
      end
      property :am_pm do
        key :type, :string
        key :description, '午前か午後か'
        key :enum, ['午前', '午後']
      end

      property :point do
        key :type, :integer
        key :description, '体調のポイント 数が多いほど良好'
        key :minimum, 1
        key :maximum, 12
      end

    end

    swagger_schema :SelfCareClassification do
      key :required, [:status_group, :classification_name]
      property :status_group do
        key :type, :string
        key :description, '体調の傾向'
        key :enum, ['良好', '注意', '悪化']
      end
      property :classification_name do
        key :type, :string
        key :description, '分類名'
        key :example, '就職活動への意欲がある'
      end

    end

    swagger_schema :SelfCareClassificationInput do
      key :required, [:status_group_id, :classification_name]
      property :status_group_id do
        key :type, :integer
        key :description, 'ステータスグループのID'
      end
      property :classification_name do
        key :type, :string
        key :description, '分類名'
        key :example, '就職活動への意欲がある'
      end

    end

    swagger_schema :SelfCareInput do
      allOf do
        schema do
          key :'$ref', 'SelfCare'
        end

        schema do
          key :required, [:classification_id]

          property :classification_id do
            key :type, :integer
            key :description, '分類ID'
          end
        end

      end

    end

    swagger_schema :SelfCareOutput do
      allOf do
        schema do
          key :'$ref', 'SelfCare'
        end

        schema do
          key :'$ref', 'SelfCareClassification'
        end
      end
    end

  end

end