module Swagger::ReframingApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_path '/reframings/{id}' do

      operation :get do
        key :description, '該当IDのReframingを取得する'
        key :operationId, :find_reframing_by_id
        key :tags, [
            'reframing',
            'ver1'
        ]

        parameter name: :id do
          key :in, :path
          key :description, 'Reframing ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        response 200 do
          key :description, 'Reframing'
          schema do
            key :required, [:reframing]

            property :reframing do
              key :'$ref', :ReframingOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_not_found_response(self, 'id', 'Reframing')
      end

      operation :put do
        key :description, '指定したReframingをアップデートする'
        key :operationId, :update_reframing_by_id

        key :tags, [
            'reframing',
            'ver1'
        ]


        parameter name: :id do
          key :in, :path
          key :description, 'Reframing ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        parameter name: :reframing do
          key :in, :body
          key :required, true
          schema do
            key :'$ref', 'ReframingInput'
          end

        end

        response 200 do
          key :description, 'Reframingの更新に成功した'
          schema do
            key :required, [:reframing]

            property :reframing do
              key :'$ref', :ReframingOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'Reframing')
        Swagger::ErrorResponseHelper.define_not_found_response(self, 'id', 'Reframing')

      end

    end

    swagger_path '/reframings' do

      operation :post do
        key :description, 'Reframingを作成'
        key :operationId, :create_reframing

        key :tags, [
            'reframing',
            'ver1'
        ]


        parameter name: :self_care do
          key :in, :body
          key :required, true
          schema do
            key :'$ref', 'ReframingInput'
          end

        end

        response 200 do
          key :description, 'Reframingの作成に成功した'
          schema do
            key :required, [:self_care]

            property :self_care do
              key :'$ref', :ReframingOutput
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'Reframing')
      end

    end

    swagger_path '/reframing/recent' do

      operation :get do
        key :description, '直近１週間のReframingリストを取得する'
        key :operationId, :find_recently_reframing

        key :tags, [
            'reframing',
            'ver1'
        ]


        response 200 do
          key :description, '直近１週間のReframingリストを取得する'
          schema do
            key :required, [:reframing, :start_date, :end_date]

            property :reframings do
              key :type, :array
              items do
                key :'$ref', :ReframingOutput
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

    swagger_path '/reframing/month' do

      operation :get do
        key :description, '指定した月のデータ一覧を取得する'
        key :operationId, :find_reframings_by_year_and_month

        key :tags, [
            'reframing',
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
            key :required, [:reframings]

            property :reframings do
              key :type, :array
              items do
                key :'$ref', :ReframingOutput
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