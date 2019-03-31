module Swagger::ProblemSolvingApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_path '/problem_solvings/{id}' do

      operation :get do
        key :description, '該当IDのProblemSolvingを取得する'
        key :operationId, :find_problem_solving_by_id
        key :tags, [
            'problem_solving',
            'ver1'
        ]

        parameter name: :id do
          key :in, :path
          key :description, 'Problem Solving ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        response 200 do
          key :description, 'ProblemSolvingを取得する'
          schema do
            key :required, [:problem_solving]

            property :problem_solving do
              key :'$ref', :ProblemSolvingOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_not_found_response(self, 'id', 'ProblemSolving')
      end

      operation :put do
        key :description, '指定したProblemSolvingをアップデートする'
        key :operationId, :update_problem_solving_by_id
        key :tags, [
            'problem_solving',
            'ver1'
        ]

        parameter name: :id do
          key :in, :path
          key :description, 'Problem Solving ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        parameter name: :problem_solving do
          key :in, :body
          key :required, true
          schema do
            key :'$ref', 'ProblemSolvingInput'
          end

        end

        response 200 do
          key :description, 'ProblemSolvingの更新に成功した'
          schema do
            key :required, [:problem_solving]

            property :problem_solving do
              key :'$ref', :ProblemSolvingOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'ProblemSolving')
        Swagger::ErrorResponseHelper.define_not_found_response(self, 'id', 'ProblemSolving')

      end

    end

    swagger_path '/problem_solvings/done/{id}' do

      operation :put do
        key :description, '指定したProblemSolvingを完了にする'
        key :operationId, :change_done_solvings
        key :tags, [
            'problem_solving',
            'ver2'
        ]

        parameter name: :id do
          key :in, :path
          key :description, 'Problem Solving ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        response 200 do
          key :description, '変更したProblemSolvingを取得する'
          schema do
            key :required, [:problem_solving]

            property :problem_solving do
              key :'$ref', :ProblemSolvingOutput
            end

          end
        end

      end

    end

    swagger_path '/problem_solvings/dones' do

      operation :get do
        key :description, '完了済みのProblemSolvingを取得する'
        key :operationId, :find_problem_solvings_of_done
        key :tags, [
            'problem_solving',
            'ver2'
        ]

        parameter name: :year do
          key :in, :query
          key :description, '取得する期間の年'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        parameter name: :month do
          key :in, :query
          key :description, '取得する期間の月'
          key :required, true
          key :type, :integer
          key :format, :int64
          key :minimum, 1
          key :exclusiveMinimum, false
          key :maximum, 12
          key :exclusiveMaximum, false
        end

        response 200 do
          key :description, '完了にしたのProblemSolvingを取得する'
          schema do
            key :required, [:problem_solving]

            property :problem_solvings do
              key :type, :array
              items do
                key :'$ref', :ProblemSolvingOutput
              end
            end

          end
        end

      end

    end

    swagger_path '/problem_solvings/doing/{id}' do

      operation :put do
        key :description, '指定したProblemSolvingを進行中にする'
        key :operationId, :change_doing_solvings
        key :tags, [
            'problem_solving',
            'ver2'
        ]

        parameter name: :id do
          key :in, :path
          key :description, 'Problem Solving ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        response 200 do
          key :description, '変更したProblemSolvingを取得する'
          schema do
            key :required, [:problem_solving]

            property :problem_solving do
              key :'$ref', :ProblemSolvingOutput
            end

          end
        end
      end
    end

    swagger_path '/problem_solvings/doings' do

      operation :get do
        key :description, '進行中のProblemSolvingを取得する'
        key :operationId, :find_problem_solvings_of_doing
        key :tags, [
            'problem_solving',
            'ver2'
        ]

        parameter name: :year do
          key :in, :query
          key :description, '取得する期間の年'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        parameter name: :month do
          key :in, :query
          key :description, '取得する期間の月'
          key :required, true
          key :type, :integer
          key :format, :int64
          key :minimum, 1
          key :exclusiveMinimum, false
          key :maximum, 12
          key :exclusiveMaximum, false
        end

        response 200 do
          key :description, '進行中のProblemSolvingを取得する'
          schema do
            key :required, [:problem_solving]

            property :problem_solvings do
              key :type, :array
              items do
                key :'$ref', :ProblemSolvingOutput
              end
            end

          end
        end

      end

    end

    swagger_path '/problem_solvings' do

      operation :post do
        key :description, 'ProblemSolvingを作成'
        key :operationId, :create_problem_solving
        key :tags, [
            'problem_solving',
            'ver1'
        ]

        parameter name: :problem_solving do
          key :in, :body
          key :required, true
          schema do
            key :'$ref', 'ProblemSolvingInput'
          end

        end

        response 200 do
          key :description, 'ProblemSolvingの作成に成功した'
          schema do
            key :required, [:problem_solving]

            property :problem_solving do
              key :'$ref', :ProblemSolvingOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'ProblemSolving')
      end

    end

    swagger_path '/problem_solvings/initialize' do

      operation :post do
        key :description, 'ProblemSolvingのデータの初期データを作成:自動セーブ用'
        key :operationId, :initialize_problem_solving
        key :tags, [
            'problem_solving',
            'ver2'
        ]

        response 200 do
          key :description, 'ProblemSolvingの初期データの作成に成功した'
          schema do
            key :required, [:problem_solving]

            property :problem_solving do
              key :'$ref', :ProblemSolvingOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'ProblemSolving')
      end

    end

    swagger_path '/problem_solvings/auto_save' do

      operation :post do
        key :description, 'ProblemSolvingを自動で保存する'
        key :operationId, :auto_save_problem_solving
        key :tags, [
            'problem_solving',
            'ver2'
        ]

        parameter name: :problem_solving do
          key :in, :body
          key :required, true
          schema do
            key :'$ref', 'ProblemSolvingAutoSaveInput'
          end

        end

        response 200 do
          key :description, 'ProblemSolvingを自動で保存する: is_draft等は不要'
          schema do
            key :required, [:problem_solving]

            property :problem_solving do
              key :'$ref', :ProblemSolvingOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'ProblemSolving')
      end

    end

    swagger_path '/problem_solvings/recent' do

      operation :get do
        key :description, '直近１週間のProblemSolvingリストを取得する'
        key :operationId, :find_recently_problem_solvings
        key :tags, [
            'problem_solving',
            'ver1'
        ]

        response 200 do
          key :description, '直近１週間のProblemSolvingリストを取得する'
          schema do
            key :required, [:problem_solvings, :start_date, :end_date]

            property :problem_solvings do
              key :type, :array
              items do
                key :'$ref', :ProblemSolvingOutput
              end
            end

            property :start_date do
              key :type, :string
              key :format, :date
              key :description, '取得する期間の開始日'
              key :example, '2019-03-01'
            end

            property :end_date do
              key :type, :string
              key :format, :date
              key :description, '取得する期間の終了日'
              key :example, '2019-03-31'
            end

          end
        end

      end

    end

    swagger_path '/problem_solvings/month' do

      operation :get do
        key :description, '指定した月のデータ一覧を取得する'
        key :operationId, :find_problem_solvings_by_year_and_month
        key :tags, [
            'problem_solving',
            'ver1'
        ]

        parameter name: :year do
          key :in, :query
          key :description, '取得する期間の年'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        parameter name: :month do
          key :in, :query
          key :description, '取得する期間の月'
          key :required, true
          key :type, :integer
          key :format, :int64
          key :minimum, 1
          key :exclusiveMinimum, false
          key :maximum, 12
          key :exclusiveMaximum, false
        end

        response 200 do
          key :description, '指定した年月のデータ一覧を取得する'
          schema do
            key :required, [:problem_solvings]

            property :problem_solvings do
              key :type, :array
              items do
                key :'$ref', :ProblemSolvingOutput
              end
            end

          end
        end

        Swagger::ErrorResponseHelper.define_bad_request_response(self, 'year')
        Swagger::ErrorResponseHelper.define_bad_request_response(self, 'month')

      end

    end

  end

end