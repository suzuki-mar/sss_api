require 'rails_helper'

describe SelfCareSerializer, :type => :serializer do

  it "必要な要素が定義されていること" do

    self_care = create(:self_care)
    attributes = SelfCareSerializer.new(self_care).attributes

    expected_keys = [:id, :log_date, :am_pm, :point, :reason]
    expect(attributes.keys).to match_array(expected_keys)
  end

  describe 'am_pm' do

    it 'amなら午前となること' do
      self_care = create(:self_care_am)
      expect(SelfCareSerializer.new(self_care).am_pm).to eq '午前'
    end

    it 'pmなら午後となること' do
      self_care = create(:self_care_pm)
      expect(SelfCareSerializer.new(self_care).am_pm).to eq '午後'
    end

  end

end
