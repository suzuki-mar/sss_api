class SelfCareSerializer < ActiveModel::Serializer
  attributes :id, :am_pm, :log_date, :point, :reason, :status_group, :classification_name

  def classification_name
    object.self_care_classification.name
  end

  def status_group
    SelfCareClassificationSerializer.convert_status_group(object.self_care_classification)
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
