module DraftableAction

  extend ActiveSupport::Concern

  def init_action(model_class)
    model = model_class.new
    raise NotImplementedError.new("initialize!を実装してください") unless model.respond_to?(:initialize!)

    model.initialize!
    render_success_with(model)
  end

  def draftable_save_action_enable_db_transaction(model)
    ActiveRecord::Base.transaction do
      error_response = create_error_response_of_invalid_draftable_save_action_params
      if error_response.present?
        raise ErrorResponseException.create_from_error_response(error_response)
        return
      end

      raise NotImplementedError.new("create_save_paramsを実装してください") unless self.respond_to?(:create_save_params, true)

      if draft_save?(model)
        model.draftable_save_of_draft!(create_save_params)
      else
        model.draftable_save_of_complete!(create_save_params)
      end

    end
    render_success_with(model)
  rescue ErrorResponseException => e
    render_with_error_response(e.error_response)
  rescue => e
    error_response = create_error_response_of_save_failer(e, model)
    render_with_error_response(error_response)
  end

  private
  def draft_save?(model)
    auto_save_action? ? model.is_draft : is_draft_param == 'true'
  end

  def auto_save_action?
    (params[:action] == 'auto_save')
  end

  def create_error_response_of_invalid_draftable_save_action_params
    if is_draft_param.nil? && !auto_save_action?
      return ErrorResponse.create_validate_error_from_messages({is_draft: "必須です"})
    end

    raise NotImplementedError.new("create_error_response_of_params_if_neededを実装してください") unless self.respond_to?(:create_error_response_of_params_if_needed, true)
    error_response = create_error_response_of_params_if_needed
    if error_response.present?
      return error_response
    end

    nil
  end

  def create_error_response_of_save_failer(error, model)
    top_key_name = model.class.to_s.underscore.to_sym
    error_messages = {}
    error_messages[top_key_name] = error.message

    return ErrorResponse.create_validate_error_from_messages(error_messages)
  end

  def is_draft_param
    params[param_top_key][:is_draft]
  end

end