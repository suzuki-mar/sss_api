class ApiDocsController < ApplicationController

  include Swagger::ApiDoc

  def index

    classes = [self.class,
               ApplicationRecord,
               ProblemSolving,
               SelfCare,
               Reframing,
               Tag,
               Documents,
               Action,
               ProblemSolvingsController,
               ReframingsController,
               SelfCaresController,
               SelfCareClassificationsController,
               DocumentsController
    ].freeze
    render json: Swagger::Blocks.build_root_json(classes)

  end
end
