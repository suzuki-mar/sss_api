module HasTagModel

  extend ActiveSupport::Concern

  included do
    scope :with_tags, -> {includes(tag_associations: :tag)}
  end


  def save_tags!(params)
    raise ArgumentError.new('tag_names_textが引数にありません') if params['tag_names_text'].nil?

    tag_names_text = params['tag_names_text'].split(',')

    is_associated = TagAssociation.reflect_on_association(self.table_name.singularize.to_sym).present?
    unless is_associated
      raise ArgumentError.new("Tagと関連付けられていないクラスが渡されました:テーブル名#{self.table_name}")
    end

    Tag.create_from_name_list_if_unexists!(tag_names_text)

    TagAssociation.create_from_tag_names_text_and_document_model_if_unexists!(tag_names_text, self)

    exsits_tags = Tag.only_associated(self )
    exsits_tag_names_text = exsits_tags.pluck(:name)
    delete_tag_names_text = exsits_tag_names_text - tag_names_text
    TagAssociation.delete_from_tag_names_text(delete_tag_names_text)

    #保存内容が反映されていない
    self.reload
  end

end