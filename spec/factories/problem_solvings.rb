FactoryBot.define do
  factory :problem_solving do
    log_date { "2019-03-25" }
    is_draft { true }
    problem_recognition { "MyText" }
    example_problem { "MyText" }
    cause { "MyText" }
    phenomenon { "MyText" }
    neglect_phenomenon { "MyText" }
    solution { "MyText" }
    execution_method { "MyText" }
    evaluation_method { "MyText" }
    progress_status {:doing}

    trait :has_tag do
      after(:create) do |problem_solving|
        tag = create(:tag)
        create(:tag_association, tag:tag, problem_solving:problem_solving)
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
