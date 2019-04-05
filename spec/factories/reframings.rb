FactoryBot.define do
  factory :reframing do

    log_date { "2019-03-25" }
    problem_reason { "MyText" }
    objective_facts { "MyText" }
    feeling { "MyString" }
    before_point { 1 }
    distortion_group { :black_and_white_thinking }
    reframing { "MyText" }
    action_plan { "MyText" }
    after_point { 1 }
    is_draft { false }

    trait :has_tag do

      transient do
        tag_count {1}
      end

      after(:create) do |reframing, evaluator|
        evaluator.tag_count.times do
          tag = create(:tag)
          create(:tag_association, tag:tag, reframing:reframing)
        end

      end
    end

    trait :draft do
      is_draft { true }
    end

    trait :completed do
      is_draft { false }
    end

  end
end
