module Swagger::Schemas::ReframingSchema

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :CognitiveDistortionBase do
      key :required, [
          :description
      ]
      property :description do
        key :type, :string
        key :description, 'その認知にになってしまっている理由'
        key :example, '面談に失敗しても仕事はできる'
      end

    end

    swagger_schema :CognitiveDistortionOutput do

      allOf do
        schema do
          key :'$ref', 'CognitiveDistortionBase'
        end
        schema do
          key :required, [
              :distortion_group_text
          ]

          property :distortion_group_text do
            key :type, :string
            key :description, '認知の歪みの種類'
            key :enum, [
                '白黒思考', '一般化のしすぎ', '心のフィルター', 'マイナス思考', '他人の考えを邪推する', '拡大解釈', '過小評価',
                '感情的決めつけ', '完璧主義', 'ラベリング', '責任をシフトする', '悲観的'
            ]
          end


        end
      end

    end

    swagger_schema :CognitiveDistortionInput do

      allOf do
        schema do
          key :'$ref', 'CognitiveDistortionBase'
        end
        schema do
          key :required, [
              :distortion_group_id
          ]

          property :distortion_group_key do
            key :type, :string
            key :description, '認知の歪みの種類'
            key :enum, [
                'black_and_white_thinking', 'too_general', 'heart_filter', 'negative_thinking', 'mislead_others_thoughts',
                'extended_interpretation', 'underestimate', 'emotional_decision', 'perfectionism', 'labeling',
                'shift_responsibility', 'pessimistic'
            ]
          end
        end

      end
    end

    swagger_schema :ReframingBase do
      key :required, [
          :log_date, :problem_reason, :objective_facts, :feeling, :before_point,
          :after_point, :tags
      ]
      property :log_date do
        key :type, :string
        key :format, :date
        key :description, '記録をした日付'
        key :example, '2019-03-03'
      end

      property :problem_reason do
        key :type, :string
        key :description, '問題となっていること'
        key :example, '話し合いに失敗したらどうしようかと考えてしまっている'
      end

      property :objective_facts do
        key :type, :string
        key :description, '客観的事実'
        key :example, 'Aさんと面談をする'
      end

      property :feeling do
        key :type, :string
        key :description, '感情'
        key :example, '不安'
      end

      property :before_point do
        key :type, :integer
        key :description, 'リフレーミング前のポイント'
        key :minimum, 1
        key :maximum, 10
      end

      property :after_point do
        key :type, :integer
        key :description, 'リフレーミング後のポイント 数が多いほど良好'
        key :minimum, 1
        key :maximum, 10
      end

    end

    swagger_schema :ReframingOutput do

      allOf do
        schema do
          key :'$ref', 'ReframingBase'
        end
        schema do
          key :required, [
              :cognitive_distortions, :is_draft_text, :feeling, :tags,:action_plans
          ]

          property :cognitive_distortions do
            key :type, :array
            items do
              key :'$ref', :CognitiveDistortionOutput
            end
          end

          property :is_draft_text do
            key :type, :string
            key :description, '記入状態'
            key :enum, [
                '下書き', '記入済み'
            ]
          end

          property :tags do
            key :type, :array
            items do
              key :'$ref', :TagOutput
            end
          end

          property :action_plans do
            key :type, :array
            items do
              key :'$ref', :ActionOutput
            end
          end

        end
      end

    end

    swagger_schema :ReframingAutoSaveInput do

      allOf do
        schema do
          key :'$ref', 'ReframingBase'
        end
        schema do
          key :required, [
              :distortion_group_id, :tag, :action_plans, :cognitive_distortions
          ]

          property :cognitive_distortions do
            key :type, :array
            items do
              key :'$ref', :CognitiveDistortionInput
            end
          end

          property :tag do
            key :'$ref', :TagInput
          end

          property :action_plans do
            key :type, :array
            items do
              key :'$ref', :ActionInput
            end
          end

        end

      end
    end

    swagger_schema :ReframingInput do

      allOf do
        schema do
          key :'$ref', 'ReframingAutoSaveInput'
        end
        schema do
          key :required, [
              :is_draft
          ]

          property :is_draft do
            key :type, :boolean
            key :description, '下書きかどうか'
          end

        end
      end
    end
  end

end