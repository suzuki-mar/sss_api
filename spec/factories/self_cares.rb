FactoryBot.define do
  factory :self_care do
    log_date {Date.today}
    am_pm {:pm}
    point {10}
    reason {"reasonreason"}
    self_care_classification

    factory :self_care_am do
      am_pm {:am}
    end

    factory :self_care_pm do
      am_pm {:pm}
    end

  end
end
