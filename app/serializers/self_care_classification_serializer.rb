class SelfCareClassificationSerializer < ActiveModel::Serializer
  attributes :status_group, :name

  def self.convert_status_group(object)
    case object.status_group
    when "good"
      "良好"
    when "normal"
      "注意"
    when "bad"
      "悪化"
    end
  end

  def status_group
    self.class.convert_status_group(object)
  end

end
