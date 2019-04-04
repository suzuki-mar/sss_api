class ReframingSerializer < ActiveModel::Serializer
  include Common::DraftSerializer

  attributes :id, :log_date, :problem_reason, :objective_facts, :feeling, :before_point,
             :distortion_group_text, :reframing, :action_plan, :after_point, :is_draft_text, :tags

  def distortion_group_text
    return nil if object.distortion_group.nil?

    values = {
      black_and_white_thinking: '白黒思考',
      too_general: '一般化のしすぎ',
      heart_filter: '心のフィルター',
      negative_thinking: 'マイナス思考',
      mislead_others_thoughts: '他人の考えを邪推する',
      extended_interpretation: '拡大解釈',
      underestimate: '過小評価',
      emotional_decision: '感情的決めつけ',
      perfectionism: '完璧主義',
      labeling: 'ラベリング',
      shift_responsibility: '責任転嫁',
      pessimistic: '悲観的'
    }

    values[object.distortion_group.to_sym]
  end

  def tags
    object.tag_associations.map do |ta|
      tag = ta.tag
      TagSerializer.new(tag).attributes
    end
  end

end
