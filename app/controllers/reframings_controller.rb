class ReframingsController < ApiControllerBase

  include Swagger::ReframingApi
  include DraftableAction

  before_action :set_reframing, only: [:show, :update, :destroy]

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'Reframing'
  end

  public
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

  def draftable_save_action

    distortion_group_number = reframing_params["distortion_group_number"].to_i
    error_response = create_error_response_by_distortion_group_number(distortion_group_number)

    if error_response.present?
      render_with_error_response(error_response)
      return
    end

    save_service = create_save_service_by_distortion_group_number(distortion_group_number)

    if save_service.execute
      render_success_with(@reframing)
    else
      error_response = ErrorResponse.create_validate_error_from_messages(save_service.error_messages)
      render_with_error_response(error_response)
    end

  end

  def create_error_response_by_distortion_group_number(distortion_group_number)
    if params[:is_draft].nil?
      return ErrorResponse.create_validate_error_from_messages({is_draft: "必須です"})
    end

    distortion_group = Reframing.distortion_groups.invert[distortion_group_number]
    if distortion_group.nil?
      return ErrorResponse.create_validate_error_from_messages({reframings: "存在しないdistortion_group_numberを指定しました:#{distortion_group_number}"})
    end

  end

  def create_save_service_by_distortion_group_number(distortion_group_number)

    distortion_group = Reframing.distortion_groups.invert[distortion_group_number]
    save_params = reframing_params.to_hash

    save_params["distortion_group"] = distortion_group
    #値があると保存に失敗する
    save_params.delete("distortion_group_number")

    DraftableSaveService.new(draft_save?, @reframing, save_params)
  end

end
