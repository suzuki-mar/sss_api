require 'rails_helper'

RSpec.describe "Documents", type: :request do

  before :all do
    @expected_response_keys = ['documents_list']
  end

  describe 'search' do

    subject do
      get "/documents/search", params:{search_params: params}
    end

    context 'タグで検索する場合' do

      before :each do
        create(:problem_solving, :has_tag, tag_count: 3, log_date: Date.yesterday)
        @search_tag = Tag.first
        create(:reframing, :set_tag, target_tag:@search_tag, log_date: Date.yesterday)
        create(:reframing, :set_tag, target_tag:@search_tag, log_date: Date.yesterday)
        create(:reframing, :set_tag, target_tag:@search_tag, log_date: Date.today)
        create(:reframing, :set_tag, target_tag:Tag.second, log_date: Date.today)
        create(:reframing, :set_tag, target_tag:@search_tag, log_date: Date.today - 2.day)
      end

      let(:params) do
        {tag_name: @search_tag.name, search_type: :tag}
      end

      it '指定したタグ名を検索で取得する取得する' do
        subject
        json = JSON.parse(response.body)
        elements_json = json['documents_list']['elements']

        expect(elements_json[0]["log_date"]).to eq(Date.today.to_s)
        expect(elements_json[0].keys).to eq(["log_date", "problem_solvings", "reframings"])
        expect(elements_json[1]['reframings'].count).to eq(2)
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

    end

    context 'パラメーターが間違っている場合' do

      context 'search_typeの指定がない' do
        let(:params) do
          {tag_name: 'hoge'}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"search_type:\tsearch_typeは必須です\n\n"}
        end

      end

      context 'search_typeが定義されていないものの場合' do
        let(:params) do
          {search_type: 'invalid'}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"search_type:\t不正なsearch_typeが渡されました:invalid\n\n"}
        end

      end

    end

  end

end
