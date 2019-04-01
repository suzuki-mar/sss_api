class SelfCareClassificationSerializer < ActiveModel::Serializer
  attributes :status_group, :display_name

  def status_group
    case object.status_group
    when "good"
      "良好"
    when "normal"
      "注意"
    when "bad"
      "悪化"
    end

  end

  def display_name
    "#{self.status_group}:#{object.name}"
  end
end
