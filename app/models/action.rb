class Action < ApplicationRecord

  include HasLogDateModel

  validates :is_draft, inclusion: {in: [true, false]}
  validates :progress_status, presence: true
  validates :due_date, presence: true, on: :completed
  validates :description, presence: true, on: :completed
  validates :log_date, log_date_type: {initailizeable_model: false }

  enum progress_status:{not_started: 1, doing: 2, done: 3}

  belongs_to :problem_solving

end
