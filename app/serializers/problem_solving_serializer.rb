class ProblemSolvingSerializer < ActiveModel::Serializer
  attributes :id, :log_date, :is_draft, :problem_recognition, :example_problem
end
