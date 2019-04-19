require 'rails_helper'

RSpec.describe "Documents", type: :request do

  before :all do
    @expected_response_keys = ['documents_list']
  end

  describe 'show' do
    before :each do
      create(:self_care, :has_action, :has_tag, log_date: Date.today)
      create(:reframing, :has_action, :has_tag, log_date: Date.today)
    end

    subject do
      get "/documents/#{log_date}/#{type}"
    end

    context 'オブジェクトが存在する場合' do
      let(:log_date){Date.today}
      let(:type){:all}

      it '指定したtypeのDocumentが入っているDocumentsを取得する' do
        subject
        json = JSON.parse(response.body)['documents']
        expect(json['reframings'].present?).to be_truthy
        expect(json['self_cares'].present?).to be_truthy
        expect(json['problem_solvings'].present?).to be_falsey
      end

    end

    context 'オブジェクトが存在する場合' do
      let(:log_date){Date.today}
      let(:type){:invalid}

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"type:\t不正なタイプが指定されました:invalid\n\n"}
      end

    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:log_date){Date.tomorrow}
      let(:type){:all}
      let(:resource_name){'Documents'}
      let(:request_method_type){:get}
    end
  end

  describe 'search' do

    subject do
      get "/documents/search", params:{search_params: params}
    end

    context 'タグで検索する場合' do
      let(:params) do
        {tag_name: tag_name, search_types: [:tag]}
      end

      before :each do
        create(:problem_solving, :has_tag, tag_count: 3, log_date: Date.yesterday)

        @search_tag = Tag.first
        create(:reframing, :set_tag, target_tag:@search_tag, log_date: Date.yesterday)
        create(:reframing, :set_tag, target_tag:@search_tag, log_date: Date.yesterday)
        create(:reframing, :set_tag, target_tag:@search_tag, log_date: Date.today)
        create(:reframing, :set_tag, target_tag:Tag.second, log_date: Date.today)
        create(:reframing, :set_tag, target_tag:@search_tag, log_date: Date.today - 2.day)

        create(:self_care, :set_tag, target_tag:@search_tag, log_date: Date.yesterday, am_pm: :pm)

      end

      context '全対象でタグが存在する場合' do
        let(:tag_name) {@search_tag.name}

        it '指定したタグ名を検索で取得する取得する' do
          subject
          json = JSON.parse(response.body)
          elements_json = json['documents_list']['elements']
          expect(elements_json[0]["log_date"]).to eq(Date.today.to_s)
          expect(elements_json[0].keys).to eq(["log_date", "problem_solvings", "reframings", "self_cares"])
          expect(elements_json[1]['reframings'].count).to eq(2)
        end

        it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
          let(:expected_response_keys){@expected_response_keys}
        end
      end

      context 'タグが存在しない場合' do
        let(:tag_name) {'not_exists'}

        it '指定したタグ名を検索で取得する取得する' do
          subject
          json = JSON.parse(response.body)
          elements_json = json['documents_list']['elements']
          expect(elements_json).to eq([])
        end

        it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
          let(:expected_response_keys){@expected_response_keys}
        end
      end

    end

    context '全対象でテキストで検索する場合' do
      let(:params) do
        {text: search_target, search_types: [:text]}
      end

      let(:search_target) {"検索ターゲット"}
      before :each do
        create(:problem_solving, log_date: Date.yesterday, problem_recognition:search_target)
        create(:reframing, log_date: Date.yesterday, problem_reason:search_target)
        create(:self_care, log_date: Date.yesterday, reason:search_target)

        create(:self_care, log_date: Date.today, reason:"hoge")
      end

      it '指定したタグ名を検索で取得する取得する' do
        subject
        json = JSON.parse(response.body)['documents_list']

        elements_json = json['elements']

        expect(elements_json[0].keys).to eq(["log_date", "problem_solvings", "reframings", "self_cares"])
        expect(elements_json.count).to eq(1)
      end

    end

    context '対象絞ってテキストとタグ名で検索する場合' do
      let(:params) do

        {tag_name: @search_tag.name, text: search_target, search_types: [:text, :tag]}
      end

      let(:search_target) {"検索ターゲット"}
      before :each do
        create(:problem_solving, :has_tag, tag_count: 3, log_date: Date.yesterday, problem_recognition:search_target)
        @search_tag = Tag.first
        create(:reframing, :set_tag, target_tag: @search_tag, log_date: Date.yesterday, problem_reason:search_target)
        create(:problem_solving, log_date: Date.today, problem_recognition:search_target)
      end

      it '指定したタグ名を検索で取得する取得する' do
        subject
        json = JSON.parse(response.body)['documents_list']
        elements_json = json['elements']
        expect(elements_json[0]['problem_solvings'].count).to eq(1)
        expect(elements_json[0]['reframings'].count).to eq(1)
      end

    end

    context 'タグで一つのタイプを検索する場合' do

      before :each do
        create(:problem_solving, :has_tag, tag_count: 3, log_date: Date.yesterday)
        @search_tag = Tag.first
        create(:reframing, :set_tag, target_tag:@search_tag, log_date: Date.yesterday)
        create(:self_care, :set_tag, target_tag:@search_tag, log_date: Date.yesterday, am_pm: :am)
      end

      let(:params) do
        {tag_name: @search_tag.name, search_types: [:tag], target_type: target_type}
      end

      context '問題解決をターゲットにする場合' do
        let(:target_type){:problem_solving}

        it '指定したタグ名を検索で取得する取得する' do
          subject
          json = JSON.parse(response.body)
          elements_json = json['documents_list']['elements']
          expect(elements_json[0]['problem_solvings'].count).to eq(1)
          expect(elements_json[0]['reframings'].count).to eq(0)
        end
      end

      context 'リフレーミングをターゲットにする場合' do
        let(:target_type){:reframing}

        it '指定したタグ名を検索で取得する取得する' do
          subject
          json = JSON.parse(response.body)
          elements_json = json['documents_list']['elements']

          expect(elements_json[0]['reframings'].count).to eq(1)
          expect(elements_json[0]['problem_solvings'].count).to eq(0)
        end
      end

      context 'セルフケアをターゲットにする場合' do
        let(:target_type){:self_care}

        it '指定したタグ名を検索で取得する取得する' do
          subject
          json = JSON.parse(response.body)
          elements_json = json['documents_list']['elements']
          expect(elements_json[0]['self_cares'].count).to eq(1)
          expect(elements_json[0]['problem_solvings'].count).to eq(0)
        end
      end

    end

    context '対象絞ってテキストで検索する場合' do
      let(:params) do
        {text: search_target, search_types: [:text], target_type: :self_care}
      end

      let(:search_target) {"検索ターゲット"}
      before :each do
        create(:problem_solving, log_date: Date.yesterday, problem_recognition:search_target)
        create(:reframing, log_date: Date.yesterday, problem_reason:search_target)
        create(:self_care, log_date: Date.yesterday, reason:search_target)
      end

      it '指定したタグ名を検索で取得する取得する' do
        subject
        json = JSON.parse(response.body)['documents_list']
        elements_json = json['elements']
        expect(elements_json[0]['self_cares'].count).to eq(1)
        expect(elements_json[0]['problem_solvings'].count).to eq(0)
        expect(elements_json[0].keys).to eq(["log_date", "problem_solvings", "reframings", "self_cares"])
      end

    end

    context '対象絞ってテキストとタグ名で検索する場合' do
      let(:params) do

        {tag_name: @search_tag.name, text: search_target, search_types: [:text, :tag], target_type: :problem_solving}
      end

      let(:search_target) {"検索ターゲット"}
      before :each do
        create(:problem_solving, :has_tag, tag_count: 3, log_date: Date.yesterday, problem_recognition:search_target)
        create(:problem_solving, log_date: Date.yesterday, problem_recognition:search_target)
        @search_tag = Tag.first
        create(:problem_solving, log_date: Date.today, problem_recognition:search_target)
      end

      it '指定したタグ名を検索で取得する取得する' do
        subject
        json = JSON.parse(response.body)['documents_list']
        elements_json = json['elements']
        expect(elements_json[0]['problem_solvings'].count).to eq(1)
        expect(elements_json[0]['reframings'].count).to eq(0)
      end

    end

    context 'パラメーターが間違っている場合' do

      context 'tag_nameがあるがsearch_typeの指定がない' do
        let(:params) do
          {tag_name: 'hoge'}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"search_type:\tsearch_typeは必須です\n\n"}
        end
      end

      context 'search_typeが定義されていないものの場合' do
        let(:params) do
          {search_types: ['invalid']}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"search_type:\t不正なsearch_typeが渡されました:invalid\n\n"}
        end

      end

      context 'target_typeが定義されていないものの場合' do
        let(:params) do
          {search_types: ['tag'], target_type: 'invalid', tag_name: 'hoge'}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"target_type:\t不正なtarget_typeが渡されました:invalid\n\n"}
        end

      end

    end

  end

end
