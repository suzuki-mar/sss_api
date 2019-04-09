module Common
  module HasTagSerializer
    extend ActiveSupport::Concern

    included do
      self.attributes :tags
    end

    def tags
      object.tag_associations.map do |ta|
        tag = ta.tag
        TagSerializer.new(tag).attributes
      end
    end
  end
end