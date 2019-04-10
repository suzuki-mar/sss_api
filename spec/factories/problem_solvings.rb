FactoryBot.define do
  factory :problem_solving do
    log_date { "2019-03-25" }
    is_draft { true }
    problem_recognition { "MyText" }
    example_problem { "MyText" }
    cause { "MyText" }
    phenomenon { "MyText" }
    neglect_phenomenon { "MyText" }
    progress_status {:doing}

    trait :has_tag do
      transient do
        tag_count {1}
      end

      after(:create) do |problem_solving, evaluator|
        evaluator.tag_count.times do
          tag = create(:tag)
          create(:tag_association, tag:tag, problem_solving:problem_solving)
        end

      end

    end

    trait :set_tag do

      transient do
        target_tag {nil}
      end

      after(:create) do |problem_solving, evaluator|
        raise ArgumentError.new('target_tagを引数で渡してください') if evaluator.target_tag.nil?
        create(:tag_association, tag:evaluator.target_tag, problem_solving:problem_solving)
      end

    end

    trait :done do
      progress_status { :done }
    end

    trait :doing do
      progress_status { :doing }
    end

    trait :draft do
      is_draft { true }
    end

    trait :completed do
      is_draft { false }
    end

  end
end
