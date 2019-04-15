require 'rails_helper'

RSpec.describe "Reframings/update", type: :request do
  before :all do
    @expected_response_keys = ['reframing']
  end

  before :each do
    reframing = create(:reframing, is_draft: !change_draft)
    create(:action, reframing:reframing)
    create(:action, reframing:reframing)
  end

  subject do
    params = reframing_params
    params[:is_draft] = change_draft
    params[:tag_names_text] = 'タグA,タグB'
    params[:actions] = actions
    params[:cognitive_distortions] = cognitive_distortions
    put "/reframings/#{id}", params: {reframing: params}
  end

  let(:actions) do
    params = []
    params << attributes_for(:action, evaluation_method:'保存するデータ')
    params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
    params
  end

  let!(:change_text){"調子がいい#{rand}"}

  context 'オブジェクトが存在する場合' do
    let(:id){1}

    let(:cognitive_distortions) do
      params = []
      params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
      params[0].delete(:reframing)
      params
    end

    context '完成版の場合' do
      let(:change_draft) {false}

      context '正常に更新できる場合' do
        let(:change_text){"調子がいい#{rand}"}

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
          expect(json['reframing']['tags'].count).to eq(2)
          expect(json['reframing']['actions'].count).to eq(2)
          expect(json['reframing']['cognitive_distortions'].count).to eq(1)
        end

        it 'DBの値が更新されていること' do
          subject
          reframing = Reframing.find(id)
          expect(reframing.feeling).to eq(change_text)
          expect(reframing.is_draft).to eq(false)

          action_count = reframing.actions.where(evaluation_method: "保存するデータ").count
          expect(action_count).to eq(2)

          cognitives = reframing.cognitive_distortions.where(description: change_text)
          expect(cognitives.first.description).to eq(change_text)
        end

        it 'タグが生成されていること' do
          expect{ subject }.to change(Tag, :count).from(0).to(2)
        end

        it 'タグ関連付けが生成されていること' do
          expect{ subject }.to change(TagAssociation, :count).from(0).to(2)
        end

        it '認知の歪みが生成されていること' do
          subject
          count = CognitiveDistortion.where(description: change_text).count
          expect(count).to eq(1)
        end

      end

      context 'バリデーションエラーの場合' do
        let(:reframing_params) do
          attributes_for(:reframing, feeling: nil, log_date: nil, distortion_group_number: 2)
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"reframing:\tValidation failed: Feeling can't be blank, Log date 日付の選択は必須です\n\n"}
        end

      end
    end

    context 'ドラフトの場合' do
      let(:change_draft) {true}

      let(:cognitive_distortions) do
        params = []
        params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
        params[0].delete(:reframing)
        params[0].delete(:distortion_group)
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

        it '認知の歪みが生成されていること' do
          subject
          count = CognitiveDistortion.where(description: change_text).count
          expect(count).to eq(1)
        end

        it 'DBの値が更新されていること' do
          subject
          reframing = Reframing.find(id)
          expect(reframing.feeling).to eq(change_text)
          expect(reframing.is_draft).to eq(true)

          action_count = reframing.actions.where(evaluation_method: "保存するデータ").count
          expect(action_count).to eq(2)
        end

      end

      context 'バリデーションエラーの場合' do
        let(:reframing_params) do
          attributes_for(:reframing, before_point: 1000, distortion_group_number: 2)
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"reframing:\tValidation failed: Before point 0から10までしか選択できない\n\n"}
        end

      end
    end

    context '保存途中でエラーになった場合' do
      let(:change_draft) {false}
      let(:tag_names_text){'タグA,タグB'}
      let(:change_text){"調子がいい#{rand}"}
      let(:reframing_params) do
        attributes_for(:reframing, feeling: change_text, distortion_group_number: 2)
      end

      context 'タグ保存で失敗した場合' do
        it 'トランザクション処理のロールバックがかかっていること' do
          allow_any_instance_of(Reframing).to receive(:save_tags!).and_raise(StandardError)

          subject
          reframing = Reframing.find(id)
          expect(reframing.feeling).not_to eq(change_text)
        end
      end

      context 'アクション保存に失敗した場合' do
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
          expect(reframing.feeling).not_to eq(change_text)
        end
      end

      context '認知の歪みの保存に失敗した場合' do

        let(:cognitive_distortions) do
          params = []
          params << attributes_for(:cognitive_distortion, :with_not_parent,  description:change_text)
          params[0].delete(:reframing)
          params[0].delete(:distortion_group)
          params
        end

        it 'トランザクション処理のロールバックがかかっていること' do
          subject
          reframing = Reframing.find(id)
          expect(reframing.feeling).not_to eq(change_text)
        end
      end

    end
  end

  context 'パラメーターが間違っている場合' do
    let(:cognitive_distortions) do
      params = []
      params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
      params[0].delete(:reframing)
      params
    end

    context 'is_draftがnilの場合' do
      let(:change_draft) {nil}
      let(:id){1}

      let(:reframing_params) do
        attributes_for(:reframing, distortion_group_number: 2)
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"is_draft:\t必須です\n" + "\n"}
      end
    end

  end

  it_behaves_like 'オブジェクトが存在しない場合' do
    let(:cognitive_distortions) do
      params = []
      params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
      params[0].delete(:reframing)
      params
    end

    let(:id){10000000}
    let(:change_draft) {true}
    let(:reframing_params) do
      attributes_for(:reframing, feeling: '調子がいい')
    end
    let(:resource_name){'Reframing'}
  end
end
