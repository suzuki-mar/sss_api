require 'rails_helper'

describe "SelfCares", type: :request do

  describe 'show' do
    before :each do
      create(:self_care)
    end

    subject! do
      get "/self_cares/#{id}"
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}

      it 'スキーマ通りのオブジェクトを取得できること' do
        json = JSON.parse(response.body)
        expected_keys = ['id', 'log_date', 'am_pm', 'point', 'reason', 'self_care_classification']
        expect(json.keys).to match_array(expected_keys)
      end

      it { expect(response.status).to eq 200 }
    end

    context 'オブジェクトが存在しない場合' do
      let(:id){99999999999}

      it 'エラースオブジェクトが返されること' do
        json = JSON.parse(response.body)
        expect(json['message']).to eq('not found')
      end

      it { expect(response.status).to eq 404 }
    end

  end

end
