require 'rails_helper'

RSpec.describe "ActionRelated", type: :request do

  describe 'add' do
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

      put "/actions/relateds/#{id}", params: {update_params: update_params}
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
          let(:error_message){"target_ids:\t存在しないActionIDに対して関連付けようとした\n" + "\n"}
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
