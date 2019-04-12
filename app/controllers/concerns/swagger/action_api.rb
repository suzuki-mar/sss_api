module Swagger::ActionApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_path '/actions/doing' do

      operation :get do
        key :description, '進行中のアクション一覧を取得する'
        key :operationId, :find_doing_actions

        key :tags, [
            'action',
            'ver3'
        ]

        response 200 do
          key :description, '進行中のアクション一覧を取得する'
          schema do
            key :required, [:actions]

            property :reframings do
              key :type, :array
              items do
                key :'$ref', :ActionWithDocumentOutput
              end
            end

          end
        end

      end

    end

    swagger_path '/actions/done' do

      operation :get do
        key :description, '進行中のアクション一覧を取得する'
        key :operationId, :find_doing_actions

        key :tags, [
            'action',
            'ver3'
        ]

        response 200 do
          key :description, '進行中のアクション一覧を取得する'
          schema do
            key :required, [:actions]

            property :reframings do
              key :type, :array
              items do
                key :'$ref', :ActionWithDocumentOutput
              end
            end

          end
        end

      end

    end

  end

end