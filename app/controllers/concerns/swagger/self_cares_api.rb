module Swagger::SelfCaresApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    include Swagger::ErrorSchema

    swagger_path '/self_cares/{id}' do

      operation :get do
        key :description, '該当IDのSelfCareを取得する'
        key :operationId, :find_self_care_by_id

        key :tags, [
            'self_care',
            'ver1'
        ]

        parameter name: :id do
          key :in, :path
          key :description, 'Self Care ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        response 200 do
          key :description, 'SelfCare'
          schema do
            key :required, [:self_care]

            property :self_care do
              key :'$ref', :SelfCareOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_not_found_response(self, 'id', 'SelfCare')
      end

      operation :put do
        key :description, '指定したSelfCareをアップデートする'
        key :operationId, :update_self_cares_by_id

        key :tags, [
            'self_care',
            'ver1'
        ]

        parameter name: :id do
          key :in, :path
          key :description, 'Self Care ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        parameter name: :self_care do
          key :in, :body
          key :required, true
          schema do
            key :'$ref', 'SelfCareInput'
          end

        end

        response 200 do
          key :description, 'SelfCareの更新に成功した'
          schema do
            key :required, [:self_care]

            property :self_care do
              key :'$ref', :SelfCareOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'SelfCare')
        Swagger::ErrorResponseHelper.define_not_found_response(self, 'id', 'SelfCare')

      end

    end

    swagger_path '/self_cares' do

      operation :post do
        key :description, 'SelfCareを作成'
        key :operationId, :create_self_cares

        key :tags, [
            'self_care',
            'ver1'
        ]

        parameter name: :self_care do
          key :in, :body
          key :required, true
          schema do
            key :'$ref', 'SelfCareInput'
          end

        end

        response 200 do
          key :description, 'SelfCareの作成に成功した'
          schema do
            key :required, [:self_care]

            property :self_care do
              key :'$ref', :SelfCareOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'SelfCare')
      end

    end

    swagger_path '/self_cares/current' do

      operation :post do
        key :description, '現在の日付のSelfCareを作成'
        key :operationId, :create_current_self_cares

        key :tags, [
            'self_care',
            'ver2'
        ]

        parameter name: :self_care do
          key :in, :body
          key :required, true
          schema do
            key :'$ref', 'SelfCareCurrentInput'
          end

        end

        response 200 do
          key :description, '現在の時刻のSelfCareの作成に成功した'
          schema do
            key :required, [:self_care]

            property :self_care do
              key :'$ref', :SelfCareOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'SelfCare')
      end

    end

    swagger_path '/self_cares/log_date_line_graph' do

      operation :get do
        key :description, '指定した期間を折れ線グラフで表示するための値を取得する'
        key :operationId, :find_log_date_line_graph

        key :tags, [
            'self_care',
            'ver3'
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
          key :description, '指定した期間を折れ線グラフで表示するための値を取得する'
          schema do
            key :required, [:date_values]

            property :date_values do
              key :type, :array
              items do
                key :'$ref', :DateValueLineGraphItem
              end
            end

          end
        end

      end

    end

    swagger_path '/self_cares/month' do

      operation :get do
        key :description, '指定した月のSelfCare一覧を取得する'
        key :operationId, :find_self_cares_by_year_and_month

        key :tags, [
            'self_care',
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
          key :description, '指定した年月のSelfCareリストを取得する'
          schema do
            key :required, [:self_cares]

            property :self_cares do
              key :type, :array
              items do
                key :'$ref', :SelfCareOutput
              end
            end

          end
        end

        Swagger::ErrorResponseHelper.define_bad_request_response(self, 'year')

      end

    end

  end



end