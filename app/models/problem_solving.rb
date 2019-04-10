class ProblemSolving < ApplicationRecord

  include Swagger::ProblemSolvingSchema
  include InitailzeableModel
  include HasLogDateModel
  include DraftableModel
  include HasTagModel
  include DocumentElementModel

  has_many :tag_associations, dependent: :nullify
  has_many :actions, dependent: :nullify

  after_initialize :sef_default_values

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


  private
  def save_actions!(params)

    exist_action_ids = params['actions'].map do |param|
      param['id']
    end.compact

    # N+1を避けるためIDが存在するものは取得する
    exist_actions = Action.where(id: exist_action_ids).where(problem_solving_id: self.id)

    #関係ないIDが渡されたら不具合として例外を出す
    invalid_parameter = (exist_action_ids.count - exist_actions.count) >= 1
    raise RuntimeError.new("関係ないActionのIDが渡されました") if invalid_parameter

    exist_actions.each do |action|

      update_param = params['actions'].find do |param|
        next if param['id'].blank?
        param['id'].to_i == action.id
      end

      action.update_attributes(update_param)
    end

    params['actions'].each do |params|
      next if params['id'].present?

     action = Action.new
     action.problem_solving = self

      action.assign_attributes(params)
      action.save!
    end

  end
end
