class ApiControllerBase < ActionController::API

  before_action :confirm_need_method_defined?

  rescue_from ActiveRecord::RecordNotFound do |exception|
    error_response = ErrorResponse.create_not_found(self.target_model_name)
    render_with_error_response(error_response)
  end

  protected
  def render_success_with(model)
    render json: model, status: 200
  end

  def render_success_with_list(models)

    model_class_name = models.first.class.to_s
    serailzer_class = "#{model_class_name}Serializer".constantize

    top_key_name = model_class_name.underscore.pluralize.to_sym

    # json化してハッシュ化しないと２重にjson化することになるので正常にrenderできない
    body = ActiveModel::Serializer::CollectionSerializer.new(
        models,
        each_serializer: serailzer_class
    ).to_json
    parsed_body = JSON.parse(body)

    response_json = {}
    response_json[top_key_name] = parsed_body

    self.render json: response_json, status: 200
  end

  def render_with_error_response(error_response)
    render json: error_response.to_hash, status: error_response.status
  end

  private
  def confirm_need_method_defined?

    unless self.respond_to?(:target_model_name, true)
      raise 'target_model_nameを実装する必要があります'
    end

  end

end
