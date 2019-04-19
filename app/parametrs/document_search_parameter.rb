class DocumentSearchParameter

  private
  SEARCH_TYPES = ['tag', 'text'].freeze
  TARGET_TYPES = ['problem_solving', 'reframing', 'self_care'].freeze

  public
  attr_reader :target_type, :search_types, :tag_name, :text, :error_messages

  def initialize(params)
    @target_type = params['target_type']
    @search_types = params['search_types']
    @tag_name = params['tag_name']
    @text = params['text']
    @error_messages = {}
  end

  def valid
    set_error_messages_if_needed
    !@error_messages.present?
  end

  def search_method_types

    @search_types.map do |type|
      if has_target_type?
        "search_from_#{type.to_s}_of_one_type".to_sym
      else
        "search_from_#{type.to_s}_of_all_type".to_sym
      end
    end

  end

  def and_search?
    @search_types.count >= 2
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

    if @target_type.present? && !TARGET_TYPES.include?(@target_type)
      @error_messages['target_type'] = "不正なtarget_typeが渡されました:#{@target_type}"
    end

    if has_search_type?(:tag) && @tag_name.blank?
      @error_messages['tag_name'] = "search_typesにtagがある場合にtag_nameは必須です"
    end

  end

  def has_search_type?(type)
    @search_types.include?(type.to_s)
  end

  def has_target_type?
    @target_type.present?
  end

end