class PieChartItem
  include ActiveModel::Serialization

  attr_reader :name, :value, :percentage

  def initialize(params)
    @name = params[:name]
    @value = params[:value]
    @percentage = params[:percentage]
  end

end