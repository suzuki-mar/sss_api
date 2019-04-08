class DocumentsController < ApiControllerBase

  include Swagger::DocumentsApi

  private
  SEARCH_TYPES = ['tag'].freeze

  protected
  def target_model_name
    'Documents'
  end

  public
  def search

    messages = create_error_messages_if_needed
    if messages.present?
      error_response = ErrorResponse.create_validate_error_from_messages(messages)
      render_with_error_response(error_response)
      return
    end

    grouped_document_ids = TagAssociation.find_grouped_document_ids_by_tag_name(search_params['tag_name'])
    documents_list = DocumentsList.create_by_grouped_document_ids(grouped_document_ids)
    documents_list.sort_by_log_date!

    render_success_with(documents_list)
  end

  private
  def search_params
    params["search_params"]
  end

  def create_error_messages_if_needed

    messages = {}
    unless search_params['search_type'].present?
      messages['search_type'] = 'search_typeは必須です'
      return messages
    end

    unless SEARCH_TYPES.include?(search_params['search_type'])
      messages['search_type'] = "不正なsearch_typeが渡されました:#{search_params['search_type']}"
      return messages
    end

  end
end
