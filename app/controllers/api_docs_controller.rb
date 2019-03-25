class ApiDocsController < ApplicationController

  include Swagger::ApiDoc

  def index

    classes = [self.class, SelfCare, SelfCaresController, ].freeze
    render json: Swagger::Blocks.build_root_json(classes)

  end
end
