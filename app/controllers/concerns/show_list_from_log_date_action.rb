module ShowListFromLogDateAction

  extend ActiveSupport::Concern

  protected

  def recent_list_action(model_class, has_tag: false)
    list = model_class.recent

    if has_tag
      list = list.with_tags
    end

    recent = Recent.new
    render_success_with_list_and_date_range(list, recent)
  end

  def month_list_action(model_class, has_tag: false)
    month_date = MonthDate.new(params["year"], params["month"])

    unless month_date.valid
      error_response = ErrorResponse.create_validate_error_from_messages(month_date.error_messages)
      render_with_error_response(error_response)
      return
    end

    list = model_class.by_month_date(month_date)

    if has_tag
      list = list.with_tags
    end

    render_success_with_list(list)
  end
end