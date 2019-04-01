module Swagger::ProblemSolvingSchema

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_schema :ProblemSolvingBase do

      key :required, [
          :log_date, :problem_recognition, :example_problem, :cause, :phenomenon, :neglect_phenomenon,
          :solution, :execution_method, :evaluation_method
      ]
      property :log_date do
        key :type, :string
        key :format, :date
        key :description, '記録をした日付'
        key :example, '2019-03-03'
      end

      property :problem_recognition do
        key :type, :string
        key :description, '問題認識'
        key :example, 'プログラミングの勉強のモチベーションがあがらない'
      end

      property :example_problem do
        key :type, :string
        key :description, '問題認識の具体化'
        key :example, '精神的に辛くなってしまった'
      end

      property :cause do
        key :type, :string
        key :description, '原因'
        key :example, 'やりたいことが見つからずにモチベーションが下がってしまったから'
      end

      property :phenomenon do
        key :type, :string
        key :description, '現象'
        key :example, 'エンジニアとしてスキルアップできない'
      end

      property :neglect_phenomenon do
        key :type, :string
        key :description, '現象を放置すると'
        key :example, 'エンジニアとして仕事をしていくのが難しくなってしまう'
      end

      property :solution do
        key :type, :string
        key :description, '解決策'
        key :example, 'モチベーションが下がってしまっても勉強できる方法をみつける'
      end

      property :execution_method do
        key :type, :string
        key :description, '解決策'
        key :example, '10分でもいいから手を動かす'
      end

      property :evaluation_method do
        key :type, :string
        key :description, ''
        key :example, '毎日GitHubに草が生えている'
      end



    end

    swagger_schema :ProblemSolvingOutput do

      allOf do
        schema do
          key :'$ref', 'ProblemSolvingBase'
        end
        schema do
          key :required, [
              :is_draft_text, :progress_status_text
          ]

          property :is_draft_text do
            key :type, :string
            key :description, '記入状態'
            key :enum, [
                '下書き', '記入済み'
            ]
          end

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

    swagger_schema :ProblemSolvingAutoSaveInput do

      allOf do
        schema do
          key :'$ref', 'ProblemSolvingBase'
        end

        schema do
          key :required, [
              :progress_status
          ]

          property :progress_status do
            key :type, :integer
            key :description, '進行状態'
          end
        end
      end
    end

    swagger_schema :ProblemSolvingInput do

      allOf do
        schema do
          key :'$ref', 'ProblemSolvingAutoSaveInput'
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