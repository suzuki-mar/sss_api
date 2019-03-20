class SelfCareSerializer < ActiveModel::Serializer
  attributes :id, :am_pm, :log_date, :point, :reason

  has_one :self_care_classification

  def am_pm

    case object.am_pm
    when "am"
      "午前"
    when "pm"
      "午後"
    end
  end

end
