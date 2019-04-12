require 'rails_helper'

RSpec.describe "ProblemSolvings", type: :request do

  before :all do
    @expected_response_keys = ['problem_solving']
  end

  describe 'auto_save' do
    before :each do
      create(:problem_solving, :draft, :has_action)
    end

    subject do
      save_params[:example_problem] = change_text
      save_params[:tag_names_text] = 'タグA,タグB'
      save_params[:actions] = actions
      params = {problem_solving: save_params}
      put "/problem_solvings/auto_save/#{id}", params: params
    end

    let(:actions) do

      # problem_solvingを生成するときに1件される
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
      params
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}
      let(:change_text){"問題例#{rand}"}

      context '正常に更新できる場合' do

        let(:save_params) do
          attributes_for(:problem_solving, example_problem: change_text)
        end

        it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
          let(:expected_response_keys){@expected_response_keys}
        end

        it '更新したオブジェクトをレスポンとして返されること' do
          subject
          json = JSON.parse(response.body)
          expect(json['problem_solving']['example_problem']).to eq(change_text)
        end

        it 'DBの値が更新されていること' do
          subject
          problem_solving = ProblemSolving.find(id)
          expect(problem_solving.example_problem).to eq(change_text)
          expect(problem_solving.is_draft).to eq(true)
        end

        it 'タグが生成されていること' do
          expect{ subject }.to change(Tag, :count).from(0).to(2)
        end

        it 'タグ関連付けが生成されていること' do
          expect{ subject }.to change(TagAssociation, :count).from(0).to(2)
        end

        it 'アクションが生成されていること' do
          expect{ subject }.to change(Action, :count).from(1).to(2)
        end

      end

      context 'バリデーションエラーの場合' do
        let(:save_params) do
          attributes_for(:problem_solving, example_problem: nil, log_date: nil)
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"problem_solving:\tValidation failed: Log date 日付の選択は必須です\n\n"}
        end

      end
    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:change_text){"問題例#{rand}"}
      let(:save_params) do
        attributes_for(:problem_solving, example_problem: '問題例')
      end
      let(:resource_name){'ProblemSolving'}
    end

    context '保存途中でエラーになった場合' do
      let(:id){1}
      let(:change_draft) {true}
      let(:change_text){"問題例#{rand}"}
      let(:save_params) do
        attributes_for(:problem_solving, example_problem: change_text)
      end

      it 'トランザクション処理のロールバックがかかっていること' do
        allow_any_instance_of(ProblemSolving).to receive(:save_tags!).and_raise(StandardError)
        subject
        problem_solving = ProblemSolving.find(id)
        expect(problem_solving.example_problem).not_to eq(change_text)
      end

    end
  end

end
