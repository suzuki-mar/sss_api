module Swagger::Schemas::DocumentsSchema

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do

    swagger_schema :Documents do

      key :required, [:log_date]

      property :log_date do
        key :type, :string
        key :format, :date
        key :description, '記録をした日付'
        key :example, '2019-03-03'
      end

      property :self_cares do
        key :type, :array
        items do
          key :'$ref', :SelfCareOutput
        end
      end

      property :problem_solvings do
        key :type, :array
        items do
          key :'$ref', :ProblemSolvingOutput
        end
      end

      property :reframings do
        key :type, :array
        items do
          key :'$ref', :ReframingOutput
        end
      end

    end

    swagger_schema :DocumentsList do
      key :required, [:elements]

      property :elements do
        key :type, :array
        items do
          key :'$ref', :Documents
        end
      end

    end
  end

end