class ActionsController < ApiControllerBase

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'Action'
    end

  def param_top_key
    :action
  end

  public
  def doing
    list = Action.only_doing.with_related_document.sort_default
    Action.set_related_actions_from_loaded_for_targets(list)
    render_success_with_list(list)
  end

  def done
    list = Action.only_done.with_related_document.sort_default
    Action.set_related_actions_from_loaded_for_targets(list)
    render_success_with_list(list)
  end

  def overdue
    list = Action.overdue.with_related_document.sort_default
    Action.set_related_actions_from_loaded_for_targets(list)
    render_success_with_list(list)
  end

  def search

    parameter = ActionSearchParameter.new(search_params)
    unless parameter.valid
      error_response = ErrorResponse.create_validate_error_from_messages(parameter.error_messages)
      render_with_error_response(error_response)
      return
    end

    action_ids = ActionIdsFinder.find_by_action_search_parameter(parameter)
    list = Action.by_ids(action_ids).with_related_document
    Action.set_related_actions_from_loaded_for_targets(list)
    render_success_with_list(list)
  end

  private
  def search_params
    params["search_params"]
  end
end