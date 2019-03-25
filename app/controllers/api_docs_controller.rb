class ApiDocsController < ApplicationController

  include Swagger::ApiDoc

  def index

    classes = [self.class,
               SelfCare,
               Reframing,
               ReframingsController,
               SelfCaresController,
               SelfCareClassificationController].freeze
    render json: Swagger::Blocks.build_root_json(classes)

  end
end
