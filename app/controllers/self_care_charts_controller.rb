class SelfCareChartsController < ApiControllerBase

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'SelfCare'
  end


  public
  def log_date_line_graph
    month_date = MonthDate.new(params["year"], params["month"])

    unless month_date.valid
      error_response = ErrorResponse.create_validate_error_from_messages(month_date.error_messages)
      render_with_error_response(error_response)
      return
    end

    list = SelfCare.by_month_date(month_date)
    items = list.map do |model|
      DateValueLineGraphItem.new(model.log_date_time, model.point)
    end

    items.sort_by!{|item| item.date}
    render_success_with_list_and_date_range(items, month_date)
  end

  def point_pie_chart
    month_date = MonthDate.new(params["year"], params["month"])

    unless month_date.valid
      error_response = ErrorResponse.create_validate_error_from_messages(month_date.error_messages)
      render_with_error_response(error_response)
      return
    end

    self_cares = SelfCare.by_month_date(month_date).with_classification
    total_self_cares_count = self_cares.count
    self_cares_grouped_by_status_group = SelfCareClassification.convert_for_grouped_by_status_group(self_cares)

    items = self_cares_grouped_by_status_group.map do |status_group, self_cares|
      name = SelfCareClassificationSerializer.convert_status_group_text(status_group)
      PieChartItem.new({name: name, value: self_cares.count, percentage: (self_cares.count / total_self_cares_count.to_f)})
    end

    render_success_with_list_and_date_range(items, month_date)
  end

end
