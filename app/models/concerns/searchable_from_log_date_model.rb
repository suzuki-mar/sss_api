module SearchableFromLogDateModel
  extend ActiveSupport::Concern

  included do
    scope :recent, -> { where(log_date: (1.week.ago)..(Date.today)) }
    scope :by_month_date, -> (month_date) { where(log_date: month_date.start_date..month_date.end_date) }
  end

end
