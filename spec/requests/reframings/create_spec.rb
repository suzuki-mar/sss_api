require 'rails_helper'

RSpec.describe "Reframings/create", type: :request do
  before :all do
    @expected_response_keys = ['reframing']
  end

  describe 'create' do
    subject do
      params = reframing_params
      params[:is_draft] = change_draft
      params[:tag_names_text] = tag_names_text
      params[:actions] = actions
      params[:cognitive_distortions] = cognitive_distortions
      post "/reframings/", params: {reframing: params}
    end

    let(:actions) do
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params
    end

    let(:change_text){"調子がいい#{rand}"}

    context 'オブジェクトが存在する場合' do
      let(:change_text){"調子がいい#{rand}"}

      let(:cognitive_distortions) do
        params = []

        params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
        params[0].delete(:reframing)
        params
      end

      context '完成版の場合' do
        let(:change_draft) {false}
        let(:tag_names_text){'タグA,タグB'}

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
            expect(json['reframing']['actions'].count).to eq(1)
          end

          it 'DBの値が更新されていること' do
            subject
            reframing = Reframing.last
            expect(reframing.feeling).to eq(change_text)
            expect(reframing.is_draft).to eq(false)

            action = reframing.actions.first
            expect(action.evaluation_method).to eq("保存するデータ")

            cognitives = reframing.cognitive_distortions.where(description: change_text)
            expect(cognitives.first.description).to eq(change_text)
          end

          it 'レコードが生成されていること' do
            expect{ subject }.to change(Reframing, :count).from(0).to(1)
          end

        end

        context 'バリデーションエラーの場合' do
          context '基本的なパラメーターにnilのパラメーターがある' do
            let(:reframing_params) do
              attributes_for(:reframing, feeling: nil, log_date: nil, distortion_group_number: 2)
            end

            it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
              let(:error_message){"reframing:\tValidation failed: Feeling can't be blank, Log date 日付の選択は必須です\n\n"}
            end

            it '新しくレコードが作成されない' do
              expect{ subject }.to change(Reframing, :count).by(0)
            end
          end

        end
      end

      context 'ドラフトの場合' do
        let(:change_draft) {true}
        let(:tag_names_text){'タグA,タグB'}

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
            expect(json['reframing']['actions'].count).to eq(1)
          end

          it 'DBの値が更新されていること' do
            subject
            reframing = Reframing.last
            expect(reframing.feeling).to eq(change_text)
            expect(reframing.is_draft).to eq(true)
          end

          it 'レコードが生成されていること' do
            expect{ subject }.to change(Reframing, :count).from(0).to(1)
          end

          it '認知の歪みが生成されていること' do
            subject
            count = CognitiveDistortion.where(description: change_text).count
            expect(count).to eq(1)
          end

        end

        context 'バリデーションエラーの場合' do
          let(:reframing_params) do
            attributes_for(:reframing, before_point: 1000, distortion_group_number: 2)
          end

          it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
            let(:error_message){"reframing:\tValidation failed: Before point 0から10までしか選択できない\n\n"}
          end

          it '新しくレコードが作成されない' do
            expect{ subject }.to change(Reframing, :count).by(0)
          end
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

      let(:cognitive_distortions) do
        params = []
        params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
        params[0].delete(:reframing)
        params[0].delete(:distortion_group)
        params
      end

      context 'タグの保存に失敗した場合' do
        it 'トランザクション処理のロールバックがかかっていること' do
          allow_any_instance_of(Reframing).to receive(:save_tags!).and_raise(ArgumentError)

          expect{subject}.not_to change{Reframing.count}
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
          expect{subject}.not_to change{Reframing.count}
        end
      end

      context '認知の歪みの保存に失敗した場合' do

        let(:cognitive_distortions) do
          params = []
          params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
          params[0].delete(:reframing)
          params[0].delete(:distortion_group)
          params
        end

        it 'トランザクション処理のロールバックがかかっていること' do
          expect{subject}.not_to change{Reframing.count}
        end
      end

    end

    context 'バリデーションエラーの場合' do
      context '基本的なパラメーターにnilのパラメーターがある' do
        let(:reframing_params) do
          attributes_for(:reframing, feeling: nil, log_date: nil, distortion_group_number: 2)
        end

        let(:actions) do
          params = []
          params << attributes_for(:action, evaluation_method:'保存するデータ')
          params
        end

        let(:cognitive_distortions) do
          params = []
          params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
          params[0].delete(:reframing)
          params[0].delete(:distortion_group)
          params
        end

        let(:change_draft) {false}
        let(:tag_names_text){'タグA,タグB'}

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"reframing:\tValidation failed: Feeling can't be blank, Log date 日付の選択は必須です\n\n"}
        end

        it '新しくレコードが作成されない' do
          expect{ subject }.to change(Reframing, :count).by(0)
        end
      end

    end

    context 'パラメーターがおかしい場合' do
      let(:tag_names_text){'タグA,タグB'}
      let(:reframing_params) do
        attributes_for(:reframing, distortion_group_number: 2)
      end
      let(:change_draft) {true}

      let(:cognitive_distortions) do
        params = []
        params << attributes_for(:cognitive_distortion, :with_not_parent, description:change_text)
        params[0].delete(:reframing)
        params[0].delete(:distortion_group)
        params
      end

      context 'is_draftがnilの場合' do
        let(:change_draft) {nil}

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"is_draft:\t必須です\n" + "\n"}
        end

      end

      context 'tag_names_textがnilの場合' do
        let(:tag_names_text){nil}
        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"tag_names_text:	tag_names_textが入力されていません\n\n"}
        end

      end
    end

  end

end
