class ReframingsController < ApiControllerBase

  include Swagger::ReframingApi
  include DraftableAction
  include AutoSaveableAction
  include ShowListFromLogDateAction

  before_action :set_reframing, only: [:update, :destroy, :auto_save]

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'Reframing'
  end

  def param_top_key
    :reframing
  end

  def create_save_params
    distortion_group_number = reframing_params["distortion_group_number"].to_i
    distortion_group = Reframing.distortion_groups.invert[distortion_group_number]
    save_params = reframing_params.to_hash

    save_params["distortion_group"] = distortion_group
    #値があると保存に失敗する
    save_params.delete("distortion_group_number")

    save_params['actions'] = SaveActionsActionHelper.create_actions_from_params(params, param_top_key)

    save_params
  end

  def create_error_response_of_params_if_needed
    distortion_group_number = reframing_params["distortion_group_number"].to_i
    distortion_group = Reframing.distortion_groups.invert[distortion_group_number]

    error_messages = []
    if distortion_group.nil?
      error_messages << "存在しないdistortion_group_numberを指定しました:#{distortion_group_number}"
    end

    if reframing_params['tag_names_text'].nil?
      error_messages << "tag_names_textが入力されていません"
    end

    if error_messages.present?
      return ErrorResponse.create_validate_error_from_messages({reframings: error_messages})
    end

    nil
  end

  def draft_save?(model)
    auto_save_action? ? model.is_draft : is_draft_param == 'true'
  end

  public
  def show
    @reframing = Reframing.where(id: params[:id]).with_tags.first

    if @reframing.nil?
      raise ActiveRecord::RecordNotFound.new("#{params[:id]}は存在しません")
    end

    render_success_with(@reframing)
  end

  def create
    @reframing = Reframing.new
    draftable_save_action_enable_db_transaction(@reframing)
  end

  def update
    draftable_save_action_enable_db_transaction(@reframing)
  end

  def recent
    recent_list_action(Reframing, has_tag: true)
  end

  def month
    month_list_action(Reframing, has_tag: true)
  end

  def init
    init_action(Reframing)
  end

  def auto_save
    draftable_save_action_enable_db_transaction(@reframing)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reframing
      id = params[:id]
      @reframing = Reframing.where(id: id).first
      if @reframing.nil?
        raise ActiveRecord::RecordNotFound.new("#{id}は存在しません")
      end
    end

    # Only allow a trusted parameter "white list" through.
    def reframing_params
      params.require(:reframing).permit(
          :log_date, :problem_reason, :objective_facts, :feeling, :before_point, :distortion_group_number,
          :reframing, :action_plan, :after_point, :tag_names_text)
    end

end
