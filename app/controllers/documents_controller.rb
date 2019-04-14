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

  private
  def search_params
    params["search_params"]
  end

end
