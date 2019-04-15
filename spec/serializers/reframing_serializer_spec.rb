require 'rails_helper'

describe ReframingSerializer, :type => :serializer do

  it "必要な要素が定義されていること" do

    reframing = create(:reframing)
    attributes = ReframingSerializer.new(reframing).attributes

    expected_keys = [:id, :log_date, :problem_reason, :objective_facts, :feeling, :before_point,
                     :action_plan, :after_point, :is_draft_text, :tags, :cognitive_distortions]
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

  describe 'tags' do

    it 'タグを取得できること' do
      reframing = create(:reframing, :has_tag)
     expect(ReframingSerializer.new(reframing).tags[0][:name]).to eq(Tag.first.name)
    end


  end

end
