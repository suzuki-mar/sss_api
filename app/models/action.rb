class Action < ApplicationRecord

  include Swagger::ActionSchema

  validates :progress_status, presence: true
  validates :due_date, presence: true
  validates :evaluation_method, presence: true
  validates :execution_method, presence: true

  enum progress_status:{not_started: 1, doing: 2, done: 3}

  belongs_to :problem_solving

end
