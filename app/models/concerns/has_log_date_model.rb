module HasLogDateModel
  extend ActiveSupport::Concern

  included do
    scope :recent, -> do
      recent = Recent.new
      where(log_date: (recent.start_date)..(recent.end_date))
    end

    scope :by_month_date, -> (month_date) { where(log_date: month_date.start_date..month_date.end_date) }
  end

end
