require 'rails_helper'

RSpec.describe "ProblemSolvings", type: :request do

  before :all do
    @expected_response_keys = ['problem_solving']
  end

  describe 'show' do
    before :each do
      create(:problem_solving)
    end

    subject do
      get "/problem_solvings/#{id}"
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:resource_name){'ProblemSolving'}
      let(:request_method_type){:get}
    end
  end

end
