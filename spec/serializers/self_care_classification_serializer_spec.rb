require 'rails_helper'

describe SelfCareClassificationSerializer, :type => :serializer do

  it "必要な要素が定義されていること" do

    self_care_classification = create(:self_care_classification)
    attributes = SelfCareClassificationSerializer.new(self_care_classification).attributes
    expect(attributes.keys).to match_array([:status_group, :name])
  end

  describe 'status_group' do

    it 'goodなら良好となること' do
      self_care_classification = create(:self_care_classification)
      self_care_classification.status_group = :good
      expect(SelfCareClassificationSerializer.new(self_care_classification).status_group).to eq '良好'
    end


    it 'normalなら注意となること' do
      self_care_classification = create(:self_care_classification)
      self_care_classification.status_group = :normal
      expect(SelfCareClassificationSerializer.new(self_care_classification).status_group).to eq '注意'
    end

    it 'badなら悪化となること' do
      self_care_classification = create(:self_care_classification)
      self_care_classification.status_group = :bad
      expect(SelfCareClassificationSerializer.new(self_care_classification).status_group).to eq '悪化'
    end

  end

end
