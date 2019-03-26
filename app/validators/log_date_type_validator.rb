class LogDateTypeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.nil?
      record.errors.add(attribute, '日付の選択は必須です')
      return
    end

    if value > Date.today
      record.errors.add(attribute, "未来の日付のは選択できません")
    end
  end



end