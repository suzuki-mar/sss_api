module Swagger::Api::DocumentsApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_path '/documents/{date}/{type}' do

      operation :get do
        key :description, '検索条件にマッチしたドキュメントを取得する'
        key :operationId, :find_document_by_id_and_type
        key :tags, [
            'document',
            'ver4'
        ]

        parameter name: :date do
          key :in, :path
          key :description, '検索する日付'
          key :required, true
          key :type, :string
          key :format, :date
        end

        parameter name: :type do
          key :in, :path
          key :description, '検索するタイプ'
          key :required, true
          key :type, :string
          key :enum, ['problem_resolving', 'reframing', 'self_care', 'all']
        end

        response 200 do
          key :description, '検索条件にマッチしたドキュメントをみる'
          schema do
            key :required, [:problem_solving]

            property :problem_solving do
              key :'$ref', :Documents
            end

          end
        end

        Swagger::ErrorResponseHelper.define_not_found_response(self, 'id', 'Document')
      end

    end

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