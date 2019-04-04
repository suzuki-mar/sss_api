module HasTagModel

  extend ActiveSupport::Concern

  def save_tags!(params)
    tag_names = params['tag_names'].split(',')

    is_associated = TagAssociation.reflect_on_association(self.table_name.singularize.to_sym).present?
    unless is_associated
      raise ArgumentError.new("Tagと関連付けられていないクラスが渡されました:テーブル名#{self.table_name}")
    end

    Tag.create_from_name_list_if_unexists!(tag_names)

    TagAssociation.create_from_tag_names_and_document_model_if_unexists!(tag_names, self)

    exsits_tags = Tag.only_associated(self )
    exsits_tag_names = exsits_tags.pluck(:name)
    delete_tag_names = exsits_tag_names - tag_names
    TagAssociation.delete_from_tag_names(delete_tag_names)
  end

end