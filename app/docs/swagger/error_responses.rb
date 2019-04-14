module Swagger::ErrorResponses


  module NotFoundError
    def self.extended(base)



      base.response 404 do
        key :description, 'Resource not found'
        schema do
          key :'$ref', :ErrorOutput
        end
      end

    end
  end

end