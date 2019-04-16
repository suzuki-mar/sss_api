require 'rails_helper'

RSpec.describe "Actions/search", type: :request do

  before :all do
    @expected_response_keys = ['actions']
  end

  subject do
    get "/actions/search", params:{search_params: params}
  end

  context 'タグで検索する場合' do
    let(:tag_name) {"検索するタグ"}

    let(:params) do
      {tag_name: search_target_tag_name, search_types: [:tag]}
    end

    let(:search_target_tag_name){tag_name}

    let(:search_tag){create(:tag, name:tag_name)}
    let!(:problem_solving){create(:problem_solving, :set_tag, :has_action, :has_tag, tag_count: 3, target_tag: search_tag, action_text:'検索するテキスト')}
    let!(:reframing){create(:reframing, :has_tag, :set_tag, :has_action, target_tag: search_tag, tag_count: 3, action_text:'検索するテキスト')}

    before :each do
      another_tag = create(:tag, name:'検索しないタグ')
      create(:self_care, :has_tag, :set_tag, :has_action, target_tag: another_tag,  tag_count: 3, action_text:'検索しないテキスト')
      # 関連しているものすべてを取得できているか確認するため
      create(:action, problem_solving: problem_solving)

      source_action = problem_solving.actions.first
      target_action = reframing.actions.first
      source_action.add_related_action!(target_action)
    end

    context 'タグが存在する場合' do
      it '指定したタグ名を検索で取得する取得する' do
        subject
        json = JSON.parse(response.body)

        expected = (problem_solving.actions.pluck(:id) + reframing.actions.pluck(:id))
        expect(json['actions'].pluck("id")).to match_array(expected)
      end

      it '関連したアクションが設定されている' do
        subject
        json = JSON.parse(response.body)
        expect(json['actions'][0]['related_actions'].count).to eq(1)
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end
    end

  end

  context 'Parentのテキストで検索する場合' do
    let(:update_text){"検索ターゲット#{rand}"}

    let(:params) do
      {text: search_target_text, search_types: [:parent_text]}
    end

    let(:search_target_text){update_text}
    let!(:problem_solving){create(:problem_solving, :has_action,  action_text:'検索するテキスト', problem_recognition:update_text)}
    let!(:self_care){create(:self_care, :has_action, action_text:'検索するテキスト', reason:update_text)}


    before :each do
      create(:reframing, :has_action, action_text:'検索しないテキスト')
    end

    it '親のドキュメントをターゲットにしたテキスト検索をすることができる' do
      expected = (problem_solving.actions.pluck(:id) + self_care.actions.pluck(:id))

      subject
      json = JSON.parse(response.body)

      expect(json['actions'].pluck("id")).to eq(expected)
    end

  end

  context 'タグ名検索と親のテキスト名で検索をする場合' do

    let(:tag_name) {"検索するタグ"}
    let(:search_target_action_text){"検索ターゲットアクション#{rand}"}

    let(:search_target_tag_name){tag_name}
    let(:search_target_text){"検索するテキスト#{rand}"}

    let(:search_tag){create(:tag, name:tag_name)}
    let!(:problem_solving){create(:problem_solving, :set_tag, :has_action, :has_tag, tag_count: 3, target_tag: search_tag, action_text:search_target_action_text)}
    let!(:self_care){create(:self_care, :has_action, action_text:search_target_action_text, reason:search_target_text)}

    before :each do
      another_tag = create(:tag, name:'検索しないタグ')
      create(:self_care, :has_tag, :set_tag, :has_action, target_tag: another_tag,  tag_count: 3, action_text:'検索しないテキスト', log_date: Date.today - 2.day)
      create(:reframing, :has_action, action_text:'検索しないテキスト')
    end

    context '存在する場合' do
      let(:params) do
        {tag_name: search_target_tag_name, text: search_target_text, search_types: [:tag, :parent_text]}
      end

      it '指定したタグ名と親のテキスト検索で取得する' do
        subject
        json = JSON.parse(response.body)
        expected = (problem_solving.actions.pluck(:id) + self_care.actions.pluck(:id))
        expect(json['actions'].pluck("id")).to eq(expected)
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end
    end

  end

  context 'テキストで検索する場合' do
    let(:params) do
      {text: search_target_text, search_types: [:text]}
    end

    let(:search_target_text){"検索ターゲット#{rand}"}
    let!(:problem_solving){create(:problem_solving, :has_action,  action_text:search_target_text)}

    before :each do
      create(:reframing, :has_action, action_text:'検索しないテキスト')
    end

    it '親のドキュメントをターゲットにしたテキスト検索をすることができる' do
      expected = problem_solving.actions.pluck(:id)
      subject
      json = JSON.parse(response.body)
      expect(json['actions'].pluck("id")).to eq(expected)
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
        {search_types: ['invalid']}
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"search_type:\t不正なsearch_typeが渡されました:invalid\n\n"}
      end
    end

    context 'search_typeがtagだがtag_nameのパラメーターがない場合' do
      let(:params) do
        {search_types: ['tag']}
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"tag_name:\tsearch_typesにtagがある場合にtag_nameは必須です\n\n"}
      end
    end

    context 'search_typeがparent_textだがtextのパラメーターがない場合' do
      let(:params) do
        {search_types: ['parent_text']}
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"text:\tsearch_typesにparent_textがある場合にtextは必須です\n\n"}
      end
    end

    context 'search_typeがtextだがtextのパラメーターがない場合' do
      let(:params) do
        {search_types: ['text']}
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"text:\tsearch_typesにtextがある場合にtextは必須です\n\n"}
      end
    end
  end

end
