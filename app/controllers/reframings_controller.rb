class ReframingsController < ApiControllerBase

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
    save_params = reframing_params.to_hash
    save_params['cognitive_distortions'] = create_cognitive_distortion_params
    save_params['actions'] = SaveActionsActionHelper.create_actions_from_params(params, param_top_key)
    save_params
  end

  def create_error_response_of_params_if_needed
    error_messages = []
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

  private
  def create_cognitive_distortion_params
    param_keys = [:description, :distortion_group, :id]

    save_params = params.require(param_top_key).require(:cognitive_distortions).map do |action_params|
      action_params.permit(param_keys).to_hash
    end

    save_params
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
          :log_date, :problem_reason, :objective_facts, :feeling, :before_point,
          :action_plan, :after_point, :tag_names_text)
    end

end
