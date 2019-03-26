class ReframingsController < ApplicationController
  include Swagger::ReframingApi

  rescue_from ActiveRecord::RecordNotFound do |exception|
    error_response = ErrorResponse.create_not_found('Reframing')
    render_with_error_response(error_response)
  end

  before_action :set_reframing, only: [:show, :update, :destroy]

  # GET /reframings
  def index
    @reframings = Reframing.all

    render json: @reframings
  end

  # GET /reframings/1
  def show
    render_success_with(@reframing)
  end

  # POST /reframings
  def create
    @reframing = Reframing.new(reframing_params)

    if @reframing.save
      render json: @reframing, status: :created, location: @reframing
    else
      render json: @reframing.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reframings/1
  def update
    begin

      if draft_save?
        @reframing.save_draft!(reframing_params)
      else
        @reframing.save_complete!(reframing_params)
      end

      render_success_with(@reframing)
    rescue => e
      error_messages = {reframing: e.message}
      error_response = ErrorResponse.create_validate_error(error_messages)
      render_with_error_response(error_response)
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reframing
      @reframing = Reframing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def reframing_params
      params.require(:reframing).permit(:log_date, :problem_reason, :objective_facts, :feeling, :before_point, :distortion_group, :integer, :reframing, :action_plan, :after_point)
    end

  def render_success_with(model)
    top_key_name = model.class.to_s.underscore.to_sym
    response_json = {}
    response_json[top_key_name] = model
    render json: response_json, status: 200
  end

  def render_with_error_response(error_response)

    render json: error_response.to_hash, status: error_response.status
  end

  def draft_save?
    params[:is_draft] == "true"
  end

end
