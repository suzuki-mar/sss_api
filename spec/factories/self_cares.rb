FactoryBot.define do
  factory :self_care do
    log_date {Date.today}
    am_pm {:pm}
    point {10}
    reason {"reasonreason"}
    self_care_classification

    trait :has_action do
      transient do
        action_text {Faker::Quote.matz}
      end

      after(:create) do |self_care, evaluator|
        create_list(:action, 1, self_care: self_care, evaluation_method:evaluator.action_text, execution_method:evaluator.action_text)
      end
    end

    trait :current_log do

      log_date {Date.today}
      am_pm {SelfCare.create_am_pm_by_date_time(DateTime.now)}

    end

    trait :has_tag do

      transient do
        tag_count {1}
      end

      after(:create) do |self_care, evaluator|
        evaluator.tag_count.times do
          tag = create(:tag)
          create(:tag_association, tag:tag, self_care:self_care)
        end

      end
    end

    trait :set_tag do

      transient do
        target_tag {nil}
      end

      after(:create) do |self_care, evaluator|
        raise ArgumentError.new('target_tagを引数で渡してください') if evaluator.target_tag.nil?
        create(:tag_association, tag:evaluator.target_tag, self_care:self_care)
      end

    end

    factory :self_care_am do
      am_pm {:am}
    end

    factory :self_care_pm do
      am_pm {:pm}
    end

  end
end
