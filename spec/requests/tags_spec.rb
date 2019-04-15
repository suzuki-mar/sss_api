require 'rails_helper'

RSpec.describe "Tags", type: :request do
  before :all do
    @expected_response_keys = ['tags']
  end

  describe 'index' do
    before :each do
      create(:tag)
    end

    subject do
      get "/tags"
    end

    context 'オブジェクトが存在する場合' do

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

      it 'タグを取得できる' do
        subject
        json = JSON.parse(response.body)
        expect(json['tags'].count).to eq(1)
      end
    end

  end

end
