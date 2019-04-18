class SelfCare::PeriodAndPointLineGraphViewModel

  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_reader :line_graph_items, :forgot_periods, :start_date, :end_date


  def initialize(self_cares, start_and_end_date)
    @line_graph_items = self_cares.map do |self_care|
      DateValueLineGraphItem.new(self_care.log_date_time, self_care.point)
    end
    @line_graph_items.sort_by!{|item| item.date}
    @start_date = start_and_end_date.start_date
    @end_date = start_and_end_date.end_date
    @forgot_periods = SelfCarePeriod.find_forgot_periods_by_confirm_range_date(@start_date..@end_date)
  end


end