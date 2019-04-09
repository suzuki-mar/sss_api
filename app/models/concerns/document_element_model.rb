module DocumentElementModel

  extend ActiveSupport::Concern

  def self.includes_related_items
    raise NotImplementedError.new('document_element_modelのクラスはincludes_related_itemsを実装してください')
  end

end