class ApiDocsController < ApplicationController

  include Swagger::ApiDoc

  def index

    classes = [self.class,
               ApplicationRecord,
               ProblemSolving,
               SelfCare,
               Reframing,
               Tag,
               ProblemSolvingsController,
               ReframingsController,
               SelfCaresController,
               SelfCareClassificationsController].freeze
    render json: Swagger::Blocks.build_root_json(classes)

  end
end
