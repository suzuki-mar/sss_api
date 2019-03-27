class MonthDate

  attr_reader :error_messages, :year, :month

  def initialize(year, month)
    @year = year.to_i
    @month = month.to_i
    @error_messages = {}
  end

  def valid

    if @month < 1 || @month > 12
      @error_messages[:month] = "月の指定がおかしいです:渡した月:#{@month}"
    end

    if @year < 1
      @error_messages[:year] = "年の指定がおかしいです:渡した年:#{@month}"
    end

    @error_messages.count < 1
  end

  def start_date
    Date.new(year, month, 1)
  end

  def end_date
    Date.new(year, month, start_date.end_of_month.day)
  end

end