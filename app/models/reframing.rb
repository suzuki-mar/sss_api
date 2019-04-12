class Reframing < ApplicationRecord

  include Swagger::ReframingSchema
  include InitailzeableModel
  include HasLogDateModel
  include ActiveModel::Validations
  include DraftableModel
  include HasTagModel
  include DocumentElementModel
  include HasActionsModel
  include SearchCop

  has_many :tag_associations, dependent: :nullify
  has_many :actions, dependent: :nullify

  validates :problem_reason, presence: true, on: :completed
  validates :objective_facts, presence: true, on: :completed
  validates :feeling, presence: true, on: :completed
  validates :reframing, presence: true, on: :completed
  validates :action_plan, presence: true, on: :completed
  validates :distortion_group, presence: true, on: :completed
  validates :log_date, log_date_type: {initailizeable_model: true }
  validates :before_point, point_type: {initailizeable_model: true }
  validates :after_point, point_type: {initailizeable_model: true }
  validates :is_draft, inclusion: {in: [true, false]}

  search_scope :search do
    attributes :problem_reason, :objective_facts, :feeling, :reframing, :action_plan
  end

  # 日本語：英語対応表
  #   '白黒思考',  black_and_white_thinking
  #   '一般化のしすぎ',  too_general
  #   '心のフィルター',  heart_filter
  #   'マイナス思考',  negative_thinking
  #   '他人の考えを邪推する',  mislead_others_thoughts
  #   '拡大解釈 extended_interpretation
  # 過小評価',  underestimate
  #   '感情的決めつけ', emotional_decision
  #   '完璧主義', perfectionism
  #   'ラベリング',  labeling
  #   '責任転嫁',  shift_responsibility
  #   '悲観的' pessimistic
  enum distortion_group: {
      black_and_white_thinking: 1, too_general: 2, heart_filter: 3,
      negative_thinking: 4, mislead_others_thoughts: 5, extended_interpretation: 6,
      underestimate: 7, emotional_decision: 8, perfectionism: 9, labeling: 10,
      shift_responsibility: 11, pessimistic: 12
  }

  # DocumentElementModel用の実装
  def self.includes_related_items
    with_tags
  end

  # DocumentElementModel用の実装終わり

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
    {}
  end

end
