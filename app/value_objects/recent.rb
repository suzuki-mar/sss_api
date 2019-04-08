# TODO: インスタンスを使い回せるようにする
class Recent

  attr_reader :start_date, :end_date

  def initialize
    @start_date = Date.today - 7.day
    @end_date = Date.today
  end

end