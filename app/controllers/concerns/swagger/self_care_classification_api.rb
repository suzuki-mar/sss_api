module Swagger::SelfCareClassificationApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    include Swagger::ErrorSchema

    swagger_path '/self_care_classifications' do

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
              key :'$ref', :SelfCareClassification
            end

          end
        end

        Swagger::ErrorResponseHelper.define_validation_failure_response(self, 'SelfCareClassification')
      end
    end
  end
end