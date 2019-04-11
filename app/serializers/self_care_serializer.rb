class SelfCareSerializer < ActiveModel::Serializer
  include Common::HasTagSerializer

  attributes :id, :am_pm, :log_date, :point, :reason, :status_group, :classification_name

  has_many :actions

  def initialize(object, options = {})
    super

    @classification_serializer = SelfCareClassificationSerializer.new(object.self_care_classification)
  end

  def classification_name
    @classification_serializer.attributes[:display_name]
  end

  def status_group
    @classification_serializer.attributes[:status_group]
  end

  def am_pm

    case object.am_pm
    when "am"
      "午前"
    when "pm"
      "午後"
    end
  end

end
