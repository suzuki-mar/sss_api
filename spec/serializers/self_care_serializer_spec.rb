require 'rails_helper'

describe SelfCareSerializer, :type => :serializer do

  describe 'attributes' do

    context 'feedbackがない場合' do
      it "必要な要素が定義されていること" do

        self_care = create(:self_care)
        attributes = SelfCareSerializer.new(self_care).attributes

        expected_keys = [:id, :log_date, :am_pm, :point, :reason, :status_group, :classification_name, :tags]
        expect(attributes.keys).to match_array(expected_keys)
      end
    end

    context 'feedbackがある場合' do
      it "基本のパラメーターにfeedback用のパラメーターがついていること" do

        self_care = create(:self_care)
        self_care.set_up_feedback

        attributes = SelfCareSerializer.new(self_care).attributes
        expected_keys = [:id, :log_date, :am_pm, :point, :reason, :status_group, :classification_name, :tags, :feedback]
        expect(attributes.keys).to match_array(expected_keys)
      end
    end

  end

  describe 'status_group' do
    it '値を取得できること' do
      self_care_classification = create(:self_care_classification, name: 'hoge', status_group: 'good')
      self_care = create(:self_care, self_care_classification: self_care_classification)
      expect(SelfCareSerializer.new(self_care).status_group).to eq '良好'
    end
  end

  describe 'classification_name' do
    it '値を取得できること' do
      self_care_classification = create(:self_care_classification, name: '分類名', status_group: 'good')
      self_care = create(:self_care, self_care_classification: self_care_classification)
      expect(SelfCareSerializer.new(self_care).classification_name).to eq '良好:分類名'
    end
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
