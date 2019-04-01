class ReframingsController < ApiControllerBase

  include Swagger::ReframingApi
  include DraftableAction
  include ShowListFromLogDateAction

  before_action :set_reframing, only: [:show, :update, :destroy, :auto_save]

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'Reframing'
  end

  def create_save_params
    distortion_group_number = reframing_params["distortion_group_number"].to_i
    distortion_group = Reframing.distortion_groups.invert[distortion_group_number]
    save_params = reframing_params.to_hash

    save_params["distortion_group"] = distortion_group
    #値があると保存に失敗する
    save_params.delete("distortion_group_number")
    save_params
  end

  def create_error_response_of_params_if_needed
    distortion_group_number = reframing_params["distortion_group_number"].to_i
    distortion_group = Reframing.distortion_groups.invert[distortion_group_number]
    if distortion_group.nil?
      return ErrorResponse.create_validate_error_from_messages({reframings: "存在しないdistortion_group_numberを指定しました:#{distortion_group_number}"})
    end

    nil
  end


  public
  def show
    render_success_with(@reframing)
  end

  def create
    @reframing = Reframing.new
    draftable_save_action(@reframing)
  end

  def update
    draftable_save_action(@reframing)
  end

  def recent
    recent_list_action(Reframing)
  end

  def month
    month_list_action(Reframing)
  end

  def init
    init_action(Reframing)
  end

  def auto_save
    draftable_save_action(@reframing)
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

end
