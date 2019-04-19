class ActionSearchParameter

  private
  SEARCH_TYPES = ['tag', 'parent_text', 'text'].freeze

  public
  attr_reader :target_type, :search_types, :tag_name, :error_messages, :text

  def initialize(params)
    @search_types = params['search_types']
    @tag_name = params['tag_name']
    @text = params['text']
    @error_messages = {}
  end

  def valid
    set_error_messages_if_needed
    !@error_messages.present?
  end

  private
  def set_error_messages_if_needed

    unless @search_types.present?
      @error_messages['search_type'] = 'search_typeは必須です'
      return
    end

    @search_types.each do |type|
      unless SEARCH_TYPES.include?(type)
        @error_messages['search_type'] = "不正なsearch_typeが渡されました:#{type}"
      end
    end

    if has_search_type?(:tag) && @tag_name.blank?
      @error_messages['tag_name'] = "search_typesにtagがある場合にtag_nameは必須です"
    end

    if has_search_type?(:parent_text) && @text.blank?
      @error_messages['text'] = "search_typesにparent_textがある場合にtextは必須です"
    end

    if has_search_type?(:text) && @text.blank?
      @error_messages['text'] = "search_typesにtextがある場合にtextは必須です"
    end

  end

  def has_search_type?(type)
    @search_types.include?(type.to_s)
  end

end