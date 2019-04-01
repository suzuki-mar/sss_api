class PointTypeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.nil? && record.validation_context == :draft
      return
    end

    is_initailizeable_model = options.has_key?(:initailizeable_model) && options[:initailizeable_model] == true
    if is_initailizeable_model && record.initailize_mode?
      return
    end

    if value.nil?
      record.errors.add(attribute, 'ポイントの選択は必須です')
      return
    end

    if value < 0
      record.errors.add(attribute, "0から10までしか選択できない")
    end

    if  value > 10
      record.errors.add(attribute, "0から10までしか選択できない")
    end
  end

end