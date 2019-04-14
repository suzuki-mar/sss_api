module Swagger::Api::SelfCareClassificationApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    include Swagger::Schemas::ErrorSchema

    swagger_path '/self_care_classifications' do

      operation :get do
        key :description, 'SelfCareClassification一覧を取得'
        key :operationId, :find_self_care_classifications

        key :tags, [
            'self_care',
            'ver2'
        ]

        response 200 do
          key :description, 'SelfCareClassificationの作成に成功した'
          schema do
            key :required, [:self_care_classifications]

            property :self_care_classifications do
              key :type, :array
              items do
                key :'$ref', :SelfCareClassificationOutPut
              end
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'SelfCareClassification')
      end

      operation :post do
        key :description, 'SelfCareClassificationを作成'
        key :operationId, :create_self_care_classification

        key :tags, [
            'self_care',
            'ver1'
        ]

        parameter name: :self_care_classification do
          key :in, :body
          key :required, true
          schema do
            key :'$ref', 'SelfCareClassificationInput'
          end

        end

        response 200 do
          key :description, 'SelfCareClassificationの作成に成功した'
          schema do
            key :required, [:self_care_classification]

            property :self_care do
              key :'$ref', :SelfCareClassificationOutPut
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'SelfCareClassification')
      end
    end
  end
end