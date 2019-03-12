FactoryBot.define do
  factory :self_care do
    log_date {Date.today}
    am_pm {:pm}
    status_group {1}
    point {10}
    reason {"reasonreason"}
  end
end
