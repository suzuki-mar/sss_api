class DocumentsListSerializer < ActiveModel::Serializer
  attributes :elements

  def elements
    object.elements.map do |e|
      DocumentsSerializer.new(e).attributes
    end
  end

  def reframings
    return [] if object.reframings.nil?
    object.reframings.map do |r|
      ReframingSerializer.new(r).attributes
    end
  end

end
