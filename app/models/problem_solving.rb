class ProblemSolving < ApplicationRecord

  include Swagger::ProblemSolvingSchema
  include InitailzeableModel
  include HasLogDateModel
  include DraftableModel
  include HasTagModel
  include DocumentElementModel
  include HasActionsModel
  include SearchCop

  has_many :tag_associations, dependent: :nullify
  has_many :actions, dependent: :nullify

  after_initialize :sef_default_values

  search_scope :search do
    attributes :problem_recognition, :example_problem, :cause, :phenomenon, :neglect_phenomenon
  end

  validates :log_date, log_date_type: {initailizeable_model: true }
  validates :problem_recognition, presence: true, on: :completed
  validates :example_problem, presence: true, on: :completed
  validates :cause, presence: true, on: :completed
  validates :phenomenon, presence: true, on: :completed
  validates :neglect_phenomenon, presence: true, on: :completed
  validates :is_draft, inclusion: {in: [true, false]}
  validates :progress_status, presence: true

  enum progress_status:{not_started: 1, doing: 2, done: 3}
  scope :only_progress_status, -> (progress_status) { where(progress_status: progress_status) }

  # DocumentElementModel用の実装
  def self.includes_related_items
    with_tags
  end

  # DocumentElementModel用の実装終わり

  def done!
    self.progress_status = :done
    self.save!
  end

  def doing!
    self.progress_status = :doing
    self.save!
  end

  def draftable_save_of_draft!(params)
    save_draft!(params)
    save_tags!(params)
    save_actions!(params)

    self.reload
  end

  def draftable_save_of_complete!(params)
    save_complete!(params)
    save_tags!(params)
    save_actions!(params)

    self.reload
  end

  protected
  def initialize_params
    {progress_status: :not_started}
  end

end
