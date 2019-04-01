module DraftableAction

  extend ActiveSupport::Concern

  def draft_save_param?
    params[:is_draft] == "true"
  end

  def init_action(model_class)
    model = model_class.new
    raise NotImplementedError.new("initialize!を実装してください") unless model.respond_to?(:initialize!)

    model.initialize!
    render_success_with(model)
  end

  def auto_save_action?
    params[:action] == 'auto_save'
  end

  def create_error_response_of_draftable_save_action
    if params[:is_draft].nil? && !auto_save_action?
      return ErrorResponse.create_validate_error_from_messages({is_draft: "必須です"})
    end

    raise NotImplementedError.new("create_error_response_of_params_if_neededを実装してください") unless self.respond_to?(:create_error_response_of_params_if_needed, true)
    error_response = create_error_response_of_params_if_needed
    if error_response.present?
      return error_response
    end

    nil
  end

  def draftable_save_action(model)

    error_response = create_error_response_of_draftable_save_action
    if error_response.present?
      render_with_error_response(error_response)
      return
    end

    is_draft_save = auto_save_action? ? model.is_draft : draft_save_param?

    raise NotImplementedError.new("create_save_paramsを実装してください") unless self.respond_to?(:create_save_params, true)
    save_service = DraftableSaveService.new(is_draft_save, model, create_save_params)

    if save_service.execute
      render_success_with(model)
    else
      error_response = ErrorResponse.create_validate_error_from_messages(save_service.error_messages)
      render_with_error_response(error_response)
    end

  end


end