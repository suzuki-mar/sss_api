module Swagger::Api::DocumentsApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_path '/documents/search' do

      operation :get do
        key :description, '指定した方法でドキュメントリストを取得する'
        key :operationId, :search_documents
        key :tags, [
            'document',
            'ver3'
        ]

        parameter name: :search_params do
          key :in, :body
          key :required, true

          schema do
            key :required, [:search_type]

            property :search_type do
              key :type, :string
              key :description, '検索するタイプ'
              key :enum, [
                  'tag'
              ]
            end

            property :tag_name do
              key :type, :string
              key :description, 'search_typeがtagの場合に必須'
              key :example, 'タグA'
            end

          end

        end

        response 200 do
          key :description, '検索した条件にマッチしたDocumentsを取得する'
          schema do
            key :required, [:documents]

            property :documents_list do
              key :'$ref', :DocumentsList
            end

          end
        end

      end

    end
  end

end