module Swagger::ApiDoc
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '4.0.0'
        key :title, 'SSS Self Social Skill'
      end

    end

  end

end