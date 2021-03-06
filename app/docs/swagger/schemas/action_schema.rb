module Swagger::Schemas::ActionSchema

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_schema :ActionSummary do
      key :required, [:evaluation_method, :execution_method]

      property :evaluation_method do
        key :type, :string
        key :description, '評価方法'
        key :example, '毎日本を10分読む週間を身についている'
      end

      property :execution_method do
        key :type, :string
        key :description, '実行方法'
        key :example, '出社時に電車乗っている時間に本を読む'
      end
    end

    swagger_schema :Action do
      key :required, [:due_date, :evaluation_method, :execution_method]

      allOf do
        schema do
          key :'$ref', 'ActionSummary'
        end
        schema do
          key :required, [
              :progress_status_text
          ]

          property :due_date do
            key :type, :string
            key :format, :date
            key :description, '締切日'
            key :example, '2019-03-03'
          end

        end
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

    swagger_schema :DetailActionOutput do

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

          property :related_actions do
            key :type, :array
            key :description, '関連しているアクション'
            items do
              key :'$ref', :ActionSummary
            end
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