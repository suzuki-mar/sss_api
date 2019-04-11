FactoryBot.define do
  factory :action do
    progress_status { 1 }
    evaluation_method { '評価方法' }
    execution_method { '実行方法' }
    due_date { "2019-04-10" }
  end
end
