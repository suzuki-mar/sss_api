class ProblemSolving < ApplicationRecord

  include Swagger::ProblemSolvingSchema

  validates :log_date, log_date_type: true
  validates :problem_recognition, presence: true, on: :completed
  validates :example_problem, presence: true, on: :completed
  validates :cause, presence: true, on: :completed
  validates :phenomenon, presence: true, on: :completed
  validates :neglect_phenomenon, presence: true, on: :completed
  validates :solution, presence: true, on: :completed
  validates :execution_method, presence: true, on: :completed
  validates :evaluation_method, presence: true, on: :completed
  validates :is_draft, inclusion: {in: [true, false]}

end
