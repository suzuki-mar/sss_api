class SelfCare::PeriodAndPointLineGraphViewModelSerializer < ActiveModel::Serializer

  attributes :line_graph_items, :forgot_periods, :start_date, :end_date

  def line_graph_items
    object.line_graph_items.map do |item|
      DateValueLineGraphItemSerializer.new(item).attributes
    end
  end

  def periods
    object.forgot_periods.map do |period|
      SelfCarePeriodSerializer.new(period).attributes
    end

  end

end