class ReframingsController < ApplicationController
  include Swagger::ReframingApi

  rescue_from ActiveRecord::RecordNotFound do |exception|
    error_response = ErrorResponse.create_not_found('Reframing')
    render_with_error_response(error_response)
  end

  before_action :set_reframing, only: [:show, :update, :destroy]

  # GET /reframings/1
  def show
    render_success_with(@reframing)
  end

  # POST /reframings
  def create
    @reframing = Reframing.new
    draftable_save_action
  end

  # PATCH/PUT /reframings/1
  def update
    draftable_save_action
  end

  def recent
    reframings = Reframing.recent
    render_success_with_list(reframings)
  end

  def month
    month_date = MonthDate.new(params["year"], params["month"])

    unless month_date.valid
      error_response = ErrorResponse.create_validate_error_from_messages(month_date.error_messages)
      render_with_error_response(error_response)
      return
    end

    reframings = Reframing.by_month_date(month_date)
    render_success_with_list(reframings)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reframing
      @reframing = Reframing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def reframing_params
      params.require(:reframing).permit(:log_date, :problem_reason, :objective_facts, :feeling, :before_point, :distortion_group_number, :integer, :reframing, :action_plan, :after_point)
    end

  def render_success_with(model)
    top_key_name = model.class.to_s.underscore.to_sym
    response_json = {}
    response_json[top_key_name] = model
    render json: response_json, status: 200
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

  def draft_save?
    params[:is_draft] == "true"
  end

  def draftable_save_action

    if params[:is_draft].nil?
      error_response = ErrorResponse.create_validate_error_from_messages({is_draft: "必須です"})
      render_with_error_response(error_response)
      return
    end

    save_params = reframing_params.to_hash

    distortion_group_number = reframing_params["distortion_group_number"].to_i
    distortion_group = Reframing.distortion_groups.invert[distortion_group_number]

    if distortion_group.nil?
      error_response = ErrorResponse.create_validate_error_from_messages({reframings: "存在しないdistortion_group_numberを指定しました:#{distortion_group_number}"})
      render_with_error_response(error_response)
      return
    end

    save_params["distortion_group"] = distortion_group
    #値があると保存に失敗する
    save_params.delete("distortion_group_number")

    begin
      if draft_save?
        @reframing.save_draft!(save_params)
      else
        @reframing.save_complete!(save_params)
      end

      render_success_with(@reframing)
    rescue => e
      error_messages = {reframing: e.message}
      error_response = ErrorResponse.create_validate_error_from_messages(error_messages)
      render_with_error_response(error_response)
    end
  end

end
