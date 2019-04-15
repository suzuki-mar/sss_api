class CognitiveDistortion < ApplicationRecord

  belongs_to :reframing

  validates :description, presence: true, on: :completed
  validates :distortion_group,  presence: true, on: :completed
  # ドラフト時も不具合のデータをうまないためにバリデーションチェックかける
  validates :distortion_group, uniqueness: { scope: :reframing_id }

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

  def self.unregistered_distortion_group_key_by_reframing_id(reframing_id)

    exists_keys = self.where(reframing_id: reframing_id).pluck(:distortion_group)
    distortion_groups.keys - exists_keys
  end

end
