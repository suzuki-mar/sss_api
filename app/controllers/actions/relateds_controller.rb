class Actions::RelatedsController < ApiControllerBase

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
    source = Action.find(params["action_id"])

    target_ids = params.require(:update_params)[:related_action_ids]
    targets = Action.by_ids(target_ids)

    unless target_ids.count == targets.count
      error_response = ErrorResponse.create_validate_error_from_messages({target_ids: "存在しないActionIDに対して関連付けようとした"})
      return render_with_error_response(error_response)
    end

    targets.each do |target|
      source.add_related_action!(target)
    end

    Action.set_related_actions_from_loaded_for_targets([source])

    render_success_with(source)
  end

end