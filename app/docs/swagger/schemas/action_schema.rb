module Swagger::Schemas::ActionSchema

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_schema :Action do
      key :required, [:due_date, :evaluation_method, :execution_method]

      property :reason do
        key :type, :string
        key :description, '体調の理由'
        key :example, 'ゲームの配信が決まってモチベーションが上がっている'
      end

      property :point do
        key :type, :integer
        key :description, '体調のポイント 数が多いほど良好'
        key :minimum, 1
        key :maximum, 12
      end

      property :due_date do
        key :type, :string
        key :format, :date
        key :description, '締切日'
        key :example, '2019-03-03'
      end
    end

    swagger_schema :ActionOutput do

      allOf do
        schema do
          key :'$ref', 'Action'
        end
        schema do
          key :required, [
              :progress_status_text
          ]

          property :progress_status_text do
            key :type, :string
            key :description, '進行状態'
            key :enum, [
                '未着手', '進行中', '完了'
            ]
          end

        end
      end
    end

    swagger_schema :ActionWithDocumentOutput do

      allOf do
        schema do
          key :'$ref', 'ActionOutput'
        end
        schema do
          key :required, [
              :parent
          ]

          property :document do
            key :type, :object
            key :description, 'SelfCareなどのDocument'
          end

        end
      end
    end


    swagger_schema :ActionInput do

      allOf do
        schema do
          key :'$ref', 'Action'
        end
        schema do
          key :required, [
              :progress_status_text
          ]

          property :progress_status do
            key :type, :integer
            key :description, '進行状態'
          end
        end
      end
    end


  end
end