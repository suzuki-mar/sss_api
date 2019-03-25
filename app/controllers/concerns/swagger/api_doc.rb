module Swagger::ApiDoc
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'SSS Self Social Skill'
      end

        #     schema do
        #       key :required, [:id]
        #       property :id do
        #         key :type, :integer
        #         key :format, :int64
        #       end
        #     end
        #   end
        #
        # end


        # parameter :SelfCareInput do
      #  schema do
      #     key :'$ref', :SelfCare
      #   end
      #
      #  key :required, true
      # end

    end

  end

end