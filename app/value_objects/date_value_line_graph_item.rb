class DateValueLineGraphItem
  include ActiveModel::Serialization

  attr_reader :date, :value

  def initialize(date, value)
    @date = date
    @value = value
  end

end