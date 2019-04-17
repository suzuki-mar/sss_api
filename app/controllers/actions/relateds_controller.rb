class Actions::RelatedsController < ApiControllerBase

  before_action :set_source
  before_action :set_targets

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'Action'
  end

  def param_top_key
    :action
  end

  public
  def link
    unless target_ids.count == @targets.count
      error_response = ErrorResponse.create_validate_error_from_messages({target_ids: "存在しないActionIDに対して関連付けを設定しようとした"})
      return render_with_error_response(error_response)
    end

    @targets.each do |target|
      @source.add_related_action!(target)
    end

    Action.set_related_actions_from_loaded_for_targets([@source])

    render_success_with(@source)
  end

  def unlink
    unless target_ids.count == @targets.count
      error_response = ErrorResponse.create_validate_error_from_messages({target_ids: "存在しないActionIDに対して関連付けを設定しようとした"})
      return render_with_error_response(error_response)
    end

    unless all_corrlect_related_taget_ids?
      error_response = ErrorResponse.create_validate_error_from_messages({target_ids: "関連づいていないActionに対して関連付けを削除しようとした"})
      return render_with_error_response(error_response)
    end

    @targets.each do |target|
      @source.remove_related_action!(target)
    end
    Action.set_related_actions_from_loaded_for_targets([@source])

    render_success_with(@source)
  end

  private
  def set_source
    @source = Action.find(params["action_id"])
  end

  def set_targets
    @targets = Action.by_ids(target_ids)
  end

  def target_ids
    params.require(:params)[:related_action_ids]
  end

  def all_corrlect_related_taget_ids?
    grouped_related_actions = GroupedRelatedActionsFinder.find_by_action_ids([@source.id])
    related_actions = grouped_related_actions[@source.id]

    @targets.all? do |target|
      related_actions.include?(target)
    end
  end

end