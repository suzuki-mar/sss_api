class DocumentsController < ApiControllerBase

  protected
  def target_model_name
    'Documents'
  end

  public
  def search
    parameter = DocumentSearchParameter.new(search_params)
    unless parameter.valid
      error_response = ErrorResponse.create_validate_error_from_messages(parameter.error_messages)
      render_with_error_response(error_response)
      return
    end

    grouped_document_ids = GroupDocumentIdsFinder.find_by_document_search_parameter(parameter)
    documents_list = DocumentsList.create_by_grouped_document_ids(grouped_document_ids)
    render_success_with(documents_list)
  end

  def show
    type = params['type'].to_sym

    unless Documents.valid_type?(type)
      error_response = ErrorResponse.create_validate_error_from_messages({type: "不正なタイプが指定されました:#{type}"})
      return render_with_error_response(error_response)
    end

    documents = Documents.find_by_log_date_and_type(params['log_date'], type)

    if documents.empty?
      error_response = ErrorResponse.create_not_found(self.target_model_name)
      return render_with_error_response(error_response)
    end

    render_success_with(documents)
  end

  private
  def search_params
    params["search_params"]
  end

end
