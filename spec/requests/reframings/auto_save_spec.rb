require 'rails_helper'

RSpec.describe "Reframings", type: :request do
  before :all do
    @expected_response_keys = ['reframing']
  end

  subject do

    params = reframing_params
    params[:tag_names_text] = 'タグA,タグB'
    params[:actions] = actions
    params[:cognitive_distortions] = cognitive_distortions
    put "/reframings/auto_save/#{id}", params: {reframing: params}
  end

  let!(:reframing){create(:reframing, :draft, :has_action)}

  let(:actions) do

    # problem_solvingを生成するときに1件される
    params = []
    params << attributes_for(:action, evaluation_method:'保存するデータ')
    params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
    params
  end

  let(:change_text){"調子がいい#{rand}"}

  context 'オブジェクトが存在する場合' do
    let(:id){1}

    let(:cognitive_distortions) do
      params = []
      params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
      params[0].delete(:reframing)
      distortion_group_keys = CognitiveDistortion.unregistered_distortion_group_key_by_reframing_id(reframing.id)
      params[0][:distortion_group] = distortion_group_keys.first
      params
    end

    context '正常に更新できる場合' do

      let(:reframing_params) do
        attributes_for(:reframing, feeling: change_text, distortion_group_number: 2)
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

      it '更新したオブジェクトをレスポンとして返されること' do
        subject
        json = JSON.parse(response.body)
        expect(json['reframing']['feeling']).to eq(change_text)
        expect(json['reframing']['actions'].count).to eq(2)
      end

      it 'DBの値が更新されていること' do
        subject
        reframing = Reframing.find(id)
        expect(reframing.feeling).to eq(change_text)
        expect(reframing.is_draft).to eq(true)
        update_count = Action.where(evaluation_method: "保存するデータ").count
        expect(update_count).to eq(2)

        cognitives = reframing.cognitive_distortions.where(description: change_text)
        expect(cognitives.first.description).to eq(change_text)
      end

    end

    context 'バリデーションエラーの場合' do
      let(:cognitive_distortions) do
        params = []
        params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
        params[0].delete(:reframing)
        params
      end

      let(:reframing_params) do
        attributes_for(:reframing, feeling: nil, log_date: nil, distortion_group_number: 2)
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"reframing:\tValidation failed: Log date 日付の選択は必須です\n\n"}
      end

    end

  end

  context '保存途中で失敗した場合' do
    let(:id){1}
    let(:change_draft) {true}
    let(:reframing_params) do
      attributes_for(:reframing, feeling: '変更するテキスト', distortion_group_number: 2)
    end

    let(:cognitive_distortions) do
      params = []
      params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
      params[0].delete(:reframing)
      params
    end

    context 'タグの保存に失敗した場合' do
      it 'トランザクション処理のロールバックがかかっていること' do
        allow_any_instance_of(Reframing).to receive(:save_tags!).and_raise(StandardError)

        subject
        reframing = Reframing.find(id)
        expect(reframing.feeling).not_to eq('変更するテキスト')
      end
    end

    context 'アクションの保存に失敗した場合' do
      let(:actions) do
        problem_solving = create(:problem_solving, :has_action)
        another_action = Action.where(problem_solving_id: problem_solving.id).first

        # problem_solvingを生成するときに1件される
        params = []
        params << attributes_for(:action, evaluation_method:'保存するデータ')
        params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
        params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: another_action.id})
        params
      end

      it 'トランザクション処理のロールバックがかかっていること' do
        subject
        reframing = Reframing.find(id)
        expect(reframing.feeling).not_to eq('変更するテキスト')
      end

    end

    context '認知の歪みの保存に失敗した場合' do

      let(:cognitive_distortions) do
        another_reframing = create(:reframing)
        another_reframing_cognitive = another_reframing.cognitive_distortions.first

        params = []
        params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
        params[0].delete(:reframing)
        params[0].delete(:distortion_group)
        params[0]['id'] = another_reframing_cognitive.id
        params
      end

      it 'トランザクション処理のロールバックがかかっていること' do
        subject
        reframing = Reframing.find(id)
        expect(reframing.feeling).not_to eq('変更するテキスト')
      end
    end

  end

  it_behaves_like 'オブジェクトが存在しない場合' do
    let(:id){10000000}
    let(:change_draft) {true}
    let(:reframing_params) do
      attributes_for(:reframing, feeling: '調子がいい')
    end
    let(:cognitive_distortions) do
      params = []
      params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
      params[0].delete(:reframing)
      params[0].delete(:distortion_group)
      params
    end
    let(:resource_name){'Reframing'}
  end

end
