module Swagger::DocumentsSchema

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

      property :self_care do
        key :'$ref', 'SelfCareOutput'
      end

      property :problem_solving do
        key :'$ref', 'ProblemSolvingOutput'
      end

      property :reframing do
        key :'$ref', 'ReframingOutput'
      end

    end
  end

end