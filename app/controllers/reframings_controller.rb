class ReframingsController < ApplicationController
  include Swagger::ReframingApi

  before_action :set_reframing, only: [:show, :update, :destroy]

  # GET /reframings
  def index
    @reframings = Reframing.all

    render json: @reframings
  end

  # GET /reframings/1
  def show
    render json: @reframing
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
    if @reframing.update(reframing_params)
      render json: @reframing
    else
      render json: @reframing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reframings/1
  def destroy
    @reframing.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reframing
      @reframing = Reframing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def reframing_params
      params.require(:reframing).permit(:log_date, :problem_reason, :objective_facts, :feeling, :before_point, :distortion_group, :integer, :reframing, :action_plan, :after_point, :is_draft)
    end
end
