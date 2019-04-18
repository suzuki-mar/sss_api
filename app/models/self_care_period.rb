class SelfCarePeriod

  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :log_date, :am_pm

  class << self
    def create_by_self_care(self_care)
      self.create_by_log_date_and_am_pm(self_care.log_date, self_care.am_pm)
    end

    def create_by_log_date_and_am_pm(log_date, am_pm)
      period = self.new
      period.log_date = log_date
      period.am_pm = am_pm.to_sym

      period
    end

    def create_now
      am_pm = SelfCare.create_am_pm_by_date_time(DateTime.now)
      self.create_by_log_date_and_am_pm(Date.today, am_pm)
    end

    def find_forgot_periods_by_confirm_range_date(range_date)

      self_cares = SelfCare.where(log_date: range_date)
      writed_periods = self_cares.map do |self_care|
        self.create_by_self_care(self_care)
      end

      all_periods = []
      (range_date).each do |date|
        all_periods << self.create_by_log_date_and_am_pm(date, :am)
        all_periods << self.create_by_log_date_and_am_pm(date, :pm)
      end

      forgot_periods = all_periods.select do |period|

        exists = writed_periods.any? do |writed_period|
          period == writed_period
        end

        !exists
      end

      forgot_periods
    end

  end

  def hash
    self.log_date.hash * self.am_pm.hash
  end

  def eql?(other)
    self == other
  end

  def ==(other)
    self.log_date == other.log_date && self.am_pm == other.am_pm
  end

  def to_s
    "log_date:#{self.log_date}\tam_pm:#{self.am_pm}"
  end

end