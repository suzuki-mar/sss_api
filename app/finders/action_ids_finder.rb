class ActionIdsFinder

  def self.find_by_action_search_parameter(parameter)
    parameter.search_types.map do |type|
      case type
      when 'tag'
        Action.find_ids_by_tag_name(parameter.tag_name)
      when 'parent_text'
        Action.find_ids_by_parent_text(parameter.text)
      when 'text'
        Action.find_ids_by_text(parameter.text)
      else
        raise ArgumentError.new("未実装のタイプが渡されました:#{type}")
      end
    end.flatten
  end

end