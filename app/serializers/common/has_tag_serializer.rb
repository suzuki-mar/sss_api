module Common
  module HasTagSerializer
    def self.included(base)
      base.attributes :tags
    end

    def tags
      object.tag_associations.map do |ta|
        tag = ta.tag
        TagSerializer.new(tag).attributes
      end
    end
  end
end