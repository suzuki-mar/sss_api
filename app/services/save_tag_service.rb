class SaveTagService

  def initialize(tag_names, target_model)
    @tag_names = tag_names
    @target_model = target_model

    is_associated = TagAssociation.reflect_on_association(@target_model.table_name.singularize.to_sym).present?
    unless is_associated
      raise ArgumentError.new("Tagと関連付けられていないクラスが渡されました:テーブル名#{@target_model.table_name}")
    end

  end

  def execute
    Tag.create_from_name_list_if_unexists!(@tag_names)

    TagAssociation.create_from_tag_names_and_document_model_if_unexists!(@tag_names, @target_model)

    exsits_tags = Tag.only_associated(@target_model)
    exsits_tag_names = exsits_tags.pluck(:name)
    delete_tag_names = exsits_tag_names - @tag_names
    TagAssociation.delete_from_tag_names(delete_tag_names)
  end

end