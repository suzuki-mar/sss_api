class GroupDocumentIdsFinder

  def self.find_by_document_search_parameter(parameter)
    group_document_ids_list = self.find_group_document_ids_list_by_parameter(parameter)
    group_document_ids = self.create_initialized_group_document_ids_by_group_document_ids_list(group_document_ids_list)

    group_document_ids_list.each do |gdi|
      gdi.each do |key, ids|
        group_document_ids[key] += ids
      end
    end

    if parameter.and_search?
      group_document_ids.each do |key, ids|
        group_document_ids[key] = ids.select{ |id| ids.count(id) == parameter.search_types.count }.uniq
      end
    else
      group_document_ids.each do |key, ids|
        ids.uniq!
      end
    end

    group_document_ids
  end

  private
  def self.find_group_document_ids_list_by_parameter(parameter)
    parameter.search_method_types.map do |type|
      case type
      when :search_from_text_of_all_type
        Documents.find_group_document_ids_by_text(parameter.text)
      when :search_from_text_of_one_type
        Documents.find_group_document_ids_by_text_and_type(parameter.text, parameter.target_type)
      when :search_from_tag_of_all_type
        TagAssociation.find_grouped_document_ids_by_tag_name(parameter.tag_name)
      when :search_from_tag_of_one_type
        TagAssociation.find_grouped_document_ids_by_tag_name_and_target_type(parameter.tag_name, parameter.target_type)
      else
        raise NotImplementedError("対応していないtypeがきました:#{type}")
      end

    end
  end

  def self.create_initialized_group_document_ids_by_group_document_ids_list(group_document_ids_list)
    keys = group_document_ids_list.map do |group_document_ids|
      group_document_ids.keys
    end.flatten.uniq

    group_document_ids = {}
    keys.each do |key|
      group_document_ids[key] = []
    end

    group_document_ids
  end

end