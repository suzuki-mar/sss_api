class ApiDocsController < ApplicationController

  include Swagger::ApiDoc

  def index

    classes = [self.class,
               ProblemSolving,
               SelfCare,
               Reframing,
               ProblemSolvingsController,
               ReframingsController,
               SelfCaresController,
               SelfCareClassificationController].freeze
    render json: Swagger::Blocks.build_root_json(classes)

  end
end
