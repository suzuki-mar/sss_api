class LogDateTypeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)

    is_initailizeable_model = options.has_key?(:initailizeable_model) && options[:initailizeable_model] == true
    if is_initailizeable_model && record.initailize_mode?
      return
    end

    if value.nil?
      record.errors.add(attribute, '日付の選択は必須です')
      return
    end

    if value > Date.today
      record.errors.add(attribute, "未来の日付のは選択できません")
    end
  end

end