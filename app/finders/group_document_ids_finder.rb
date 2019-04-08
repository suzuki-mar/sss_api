class GroupDocumentIdsFinder

  def self.find_by_document_search_parameter(parameter)
    if parameter.target_type.present?
      TagAssociation.find_grouped_document_ids_by_tag_name_and_target_type(parameter.tag_name, parameter.target_type)
    else
      TagAssociation.find_grouped_document_ids_by_tag_name(parameter.tag_name)
    end
  end

end