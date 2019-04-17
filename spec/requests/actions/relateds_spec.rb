require 'rails_helper'

RSpec.describe "ActionRelated", type: :request do

  describe 'link' do
    let(:source_action){create(:action, :with_parent)}
    let(:target_ids) do
      create(:action, :with_parent)
      ids = Action.ids
      ids.delete(source_action.id)
      ids
    end

    subject do
      update_params = {}
      update_params[:related_action_ids] = target_ids

      put "/actions/relateds/#{id}", params: {params: update_params}
    end

    context 'ターゲットが存在する場合' do
      let(:id){source_action.id}


      it '関連つけたアクションのレスポンスも含めて取得できている' do
        subject
        json = JSON.parse(response.body)['action']
        expect(json['related_actions'].count).to eq(1)
      end

      it 'アクションの関連付けが更新されている' do
        expect{ subject }.to change(ActionRelatedAction, :count).from(0).to(1)
      end

    end

    context 'パラメーターエラーの場合' do
      let(:id){source_action.id}

      context '存在しないアクションIDを指定した場合' do
        let(:change_draft) {nil}
        let(:target_ids) do
          [99999999999999]
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"target_ids:\t存在しないActionIDに対して関連付けを設定しようとした\n" + "\n"}
        end
      end
    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:target_ids) do
        [99999999999999]
      end
      let(:resource_name){'Action'}
    end
  end

  describe 'unlink' do
    let(:source_action){create(:action, :with_parent)}
    let(:target_action){create(:action, :with_parent)}

    let(:target_ids) do
      [target_action.id]
    end

    before :each do

      source_action.add_related_action!(target_action)
      create(:action_related_action, source: source_action)
    end

    subject do
      params = {}
      params[:related_action_ids] = target_ids

      delete "/actions/relateds/#{id}", params: {params: params}
    end

    context 'ターゲットが存在する場合' do
      let(:id){source_action.id}

      it '削除していないアクションの関連付けも含めて取得できている' do
        subject
        json = JSON.parse(response.body)['action']
        expect(json['related_actions'].count).to eq(1)
      end

      it 'アクションの関連付けが更新されている' do
        expect{ subject }.to change(ActionRelatedAction, :count).from(2).to(1)
      end

    end

    context 'パラメーターエラーの場合' do
      let(:id){source_action.id}

      context '存在しないアクションIDを指定した場合' do
        let(:target_ids) do
          [99999999999999]
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"target_ids:\t存在しないActionIDに対して関連付けを設定しようとした\n" + "\n"}
        end
      end

      context '関連づいていないアクションIDを指定した場合' do
        let(:target_ids) do
          unrleated_action = create(:action, :with_parent)
          [target_action.id, unrleated_action.id]
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"target_ids:\t関連づいていないActionに対して関連付けを削除しようとした\n" + "\n"}
        end
      end


    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:target_ids) do
        [99999999999999]
      end
      let(:resource_name){'Action'}
    end
  end

end
