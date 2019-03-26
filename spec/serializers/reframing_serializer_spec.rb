require 'rails_helper'

describe ReframingSerializer, :type => :serializer do

  it "必要な要素が定義されていること" do

    reframing = create(:reframing)
    attributes = ReframingSerializer.new(reframing).attributes

    expected_keys = [:id, :log_date, :problem_reason, :objective_facts, :feeling, :before_point, :distortion_group_text,
                     :reframing, :action_plan, :after_point, :is_draft_text]
    expect(attributes.keys).to match_array(expected_keys)
  end

  describe 'is_draft_text' do
    it "trueなら下書きとなること" do
      reframing = create(:reframing, is_draft: true)
      expect(ReframingSerializer.new(reframing).is_draft_text).to eq '下書き'
    end
    it "falseなら記入済みとなること" do
      reframing = create(:reframing, is_draft: false)
      expect(ReframingSerializer.new(reframing).is_draft_text).to eq '記入済み'
    end
  end

  describe 'distortion_group_text' do

    variables =
      {
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

    variables.each do |key, text|
      it "#{key.to_s}なら#{text}となること" do
        reframing = create(:reframing, distortion_group: key)
        expect(ReframingSerializer.new(reframing).distortion_group_text).to eq text
      end
    end
  end

end
