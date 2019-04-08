class DocumentsController < ApiControllerBase

  include Swagger::DocumentsApi

  private
  SEARCH_TYPES = ['tag'].freeze
  TARGET_TYPES = ['problem_solving', 'reframing'].freeze

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

    grouped_document_ids = if search_params['target_type'].present?
                             TagAssociation.find_grouped_document_ids_by_tag_name_and_target_type(search_params['tag_name'], search_params['target_type'])
                           else
                             TagAssociation.find_grouped_document_ids_by_tag_name(search_params['tag_name'])
                            end

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

    if search_params['target_type'].present? && !TARGET_TYPES.include?(search_params['target_type'])
      messages['target_type'] = "不正なtarget_typeが渡されました:#{search_params['target_type']}"
      return messages
    end

  end
end
