require 'rails_helper'

describe CognitiveDistortionSerializer, :type => :serializer do

  it "必要な要素が定義されていること" do

    model = create(:cognitive_distortion)
    attributes = CognitiveDistortionSerializer.new(model).attributes

    expected_keys = [:id, :description, :distortion_group_text]
    expect(attributes.keys).to match_array(expected_keys)
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
        reframing = create(:cognitive_distortion, distortion_group: key)
        expect(CognitiveDistortionSerializer.new(reframing).distortion_group_text).to eq text
      end
    end
  end

end
