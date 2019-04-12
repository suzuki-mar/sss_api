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

            property :actions do
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
        key :description, '完了したアクション一覧を取得する'
        key :operationId, :find_done_actions

        key :tags, [
            'action',
            'ver3'
        ]

        response 200 do
          key :description, '完了したアクション一覧を取得する'
          schema do
            key :required, [:actions]

            property :actions do
              key :type, :array
              items do
                key :'$ref', :ActionWithDocumentOutput
              end
            end

          end
        end

      end

    end

    swagger_path '/actions/search' do

      operation :get do
        key :description, '指定した方法でアクション一覧を取得する'
        key :operationId, :search_actions

        key :tags, [
            'action',
            'ver3'
        ]

        parameter name: :search_params do
          key :in, :body
          key :required, true

          schema do
            key :required, [:search_type]

            property :search_types do
              key :type, :array
              items do
                key :type, :string
                key :description, '検索するタイプ'
                key :enum, [
                    'tag', 'text'
                ]
              end
            end

            property :tag_name do
              key :type, :string
              key :description, 'search_typesがtagの場合に必須'
              key :example, 'タグA'
            end

            property :text do
              key :type, :string
              key :description, 'search_typesがtextの場合に必須'
              key :example, 'タグA'
            end

          end

        end

        response 200 do
          key :description, '進行中のアクション一覧を取得する'
          schema do
            key :required, [:actions]

            property :actions do
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