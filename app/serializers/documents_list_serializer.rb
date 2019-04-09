class DocumentsListSerializer < ActiveModel::Serializer
  attributes :elements

  def elements
    object.elements.map do |e|
      DocumentsSerializer.new(e).attributes
    end
  end

end
