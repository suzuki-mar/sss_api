class SelfCarePeriodSerializer < ActiveModel::Serializer
  attributes :am_pm, :log_date

  def am_pm

    case object.am_pm.to_s
    when "am"
      "午前"
    when "pm"
      "午後"
    end
  end

end
