FactoryBot.define do
  factory :action do
    progress_status { 1 }
    description { "MyText" }
    due_date { "2019-04-10" }
    log_date { "2019-04-10" }
    problem_solving
    is_draft {true}
  end
end
