module Swagger::ErrorSchema
  extend ActiveSupport::Concern

  include Swagger::Blocks

  included do
    swagger_schema :ErrorOutput do

      key :required, [:message]
      property :message do
        key :type, :string
      end

    end
  end

end