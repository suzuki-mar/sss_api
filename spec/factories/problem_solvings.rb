FactoryBot.define do
  factory :problem_solving do
    log_date { "2019-03-25" }
    is_draft { false }
    problem_recognition { "MyText" }
    example_problem { "MyText" }
    cause { "MyText" }
    phenomenon { "MyText" }
    neglect_phenomenon { "MyText" }
    solution { "MyText" }
    execution_method { "MyText" }
    evaluation_method { "MyText" }
  end
end
