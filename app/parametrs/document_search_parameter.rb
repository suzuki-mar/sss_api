class DocumentSearchParameter

  private
  SEARCH_TYPES = ['tag'].freeze
  TARGET_TYPES = ['problem_solving', 'reframing', 'self_care'].freeze

  public
  attr_reader :target_type, :search_type, :tag_name, :error_messages

  def initialize(params)
    @target_type = params['target_type']
    @search_type = params['search_type']
    @tag_name = params['tag_name']
    @error_messages = {}
  end

  def valid
    set_error_messages_if_needed
    !@error_messages.present?
  end

  private
  def set_error_messages_if_needed

    unless @search_type.present?
      @error_messages['search_type'] = 'search_typeは必須です'
      return
    end

    unless SEARCH_TYPES.include?(@search_type)
      @error_messages['search_type'] = "不正なsearch_typeが渡されました:#{@search_type}"
      return
    end

    if @target_type.present? && !TARGET_TYPES.include?(@target_type)
      @error_messages['target_type'] = "不正なtarget_typeが渡されました:#{@target_type}"
      return
    end

  end


end