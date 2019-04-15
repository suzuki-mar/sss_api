module Swagger::Api::TagApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_path '/tags' do

      operation :get do
        key :description, 'タグ一覧を取得する'
        key :operationId, :find_tags
        key :tags, [
            'tag',
            'ver4'
        ]

        response 200 do
          key :description, 'タグ一覧を取得する'
          schema do
            key :required, [:tags]

            property :tags do
              key :type, :array
              items do
                key :'$ref', :TagOutput
              end
            end

          end
        end

      end
    end
  end

end