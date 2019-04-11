module SaveActionsActionHelper

  def self.create_actions_from_params(params, params_top_key)
    action_param_keys = [:progress_status, :evaluation_method, :execution_method, :due_date, :id]
    action_params = params.require(params_top_key).require(:actions).map do |action_params|
      action_params.permit(action_param_keys).to_hash
    end

    action_params.each do |action_param|
      progress_status_number = action_param["progress_status"].to_i
      action_param['progress_status'] = Action.progress_statuses.invert[progress_status_number]
    end

    action_params
  end

end