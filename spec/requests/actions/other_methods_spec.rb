require 'rails_helper'

RSpec.describe "Actions", type: :request do

  before :all do
    @expected_response_keys = ['actions']
  end

  describe 'doing' do
    before :each do
      # 全種別を対象に作成する
      problem_solving = create(:problem_solving, :has_action, :has_tag, tag_count: 3)
      reframing = create(:reframing, :has_action, :has_tag, tag_count: 3)
      create(:self_care, :has_action, :has_tag, tag_count: 3)

      source_action = problem_solving.actions.first
      target_action = reframing.actions.first
      source_action.add_related_action!(target_action)

      Action.update_all({progress_status: :doing})

      # 進行状態が違うのは取得しないようにする
      problem_solving = create(:problem_solving, :has_action, :has_tag, tag_count: 3)
      problem_solving.actions.update_all(progress_status: :done)
      problem_solving = create(:problem_solving, :has_action, :has_tag, tag_count: 3)
      problem_solving.actions.update_all(progress_status: :not_started)

    end

    subject do
      get "/actions/doing"
    end

    context '進行中のアクションを取得することができる' do

      it '正しいレスポンスが帰っていること' do
        subject
        json = JSON.parse(response.body)['actions']
        expect(json.count).to eq(3)
        # タグを取得したときにN+1になっていないか なっていたらBulletで気づける
        expect(json[0]['document']['tags'].count).to eq(3)
        expect(json[0]['document']['type']).to eq('problem_solving')
        expect(json[0]['related_actions'].count).to eq(1)
      end

    end

  end

  describe 'done' do
    before :each do
      # 全種別を対象に作成する
      problem_solving = create(:problem_solving, :has_action, :has_tag, tag_count: 3)
      reframing = create(:reframing, :has_action, :has_tag, tag_count: 3)
      create(:self_care, :has_action, :has_tag, tag_count: 3)

      source_action = problem_solving.actions.first
      target_action = reframing.actions.first
      source_action.add_related_action!(target_action)

      Action.update_all({progress_status: :done})

      # 進行状態が違うのは取得しないようにする
      problem_solving = create(:problem_solving, :has_action, :has_tag, tag_count: 3)
      problem_solving.actions.update_all(progress_status: :doing)
      problem_solving = create(:problem_solving, :has_action, :has_tag, tag_count: 3)
      problem_solving.actions.update_all(progress_status: :not_started)
    end

    subject do
      get "/actions/done"
    end

    context '進行中のアクションを取得することができる' do

      it '正しいレスポンスが帰っていること' do
        subject
        json = JSON.parse(response.body)['actions']

        expect(json.count).to eq(3)
        # タグを取得したときにN+1になっていないか なっていたらBulletで気づける
        expect(json[0]['document']['tags'].count).to eq(3)
        expect(json[0]['document']['type']).to eq('problem_solving')
        expect(json[0]['related_actions'].count).to eq(1)

      end

    end

  end

  describe 'related#PUT' do
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


  end

end
