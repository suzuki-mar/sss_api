require 'rails_helper'

RSpec.describe "Actions", type: :request do

  before :all do
    @expected_response_keys = ['action']
  end

  describe 'doing' do
    before :each do
      # 全種別を対象に作成する
      create(:problem_solving, :has_tag, tag_count: 3)
      create(:reframing, :has_tag, tag_count: 3)
      create(:self_care, :has_tag, tag_count: 3)

      Action.update_all({progress_status: :doing})

      # 進行状態が違うのは取得しないようにする
      problem_solving = create(:problem_solving, :has_tag, tag_count: 3)
      problem_solving.actions.update_all(progress_status: :done)
      problem_solving = create(:problem_solving, :has_tag, tag_count: 3)
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
      end

    end

  end

  describe 'done' do
    before :each do
      # 全種別を対象に作成する
      create(:problem_solving, :has_tag, tag_count: 3)
      create(:reframing, :has_tag, tag_count: 3)
      create(:self_care, :has_tag, tag_count: 3)

      Action.update_all({progress_status: :done})

      # 進行状態が違うのは取得しないようにする
      problem_solving = create(:problem_solving, :has_tag, tag_count: 3)
      problem_solving.actions.update_all(progress_status: :doing)
      problem_solving = create(:problem_solving, :has_tag, tag_count: 3)
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
      end

    end

  end

end
