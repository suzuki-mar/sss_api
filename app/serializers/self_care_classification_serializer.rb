class SelfCareClassificationSerializer < ActiveModel::Serializer
  attributes :id, :status_group, :display_name

  def self.convert_status_group_text(status_group)
    case status_group
    when "good"
      "良好"
    when "normal"
      "注意"
    when "bad"
      "悪化"
    end
  end

  def status_group
    self.class.convert_status_group_text(object.status_group)
  end

  def display_name
    "#{self.status_group}:#{object.name}"
  end
end
