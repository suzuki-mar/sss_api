class PieChartItemSerializer < ActiveModel::Serializer
  attributes :percentage, :name, :value

  def percentage
    object.percentage * 100
  end
end
