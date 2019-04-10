require 'rails_helper'

RSpec.describe "ProblemSolvings/create", type: :request do

  before :all do
    @expected_response_keys = ['problem_solving']
  end


  subject do
    params = problem_solving_params
    params[:is_draft] = change_draft
    params[:actions] = actions
    params[:tag_names_text] = 'タグA,タグB'
    post "/problem_solvings/", params: {problem_solving: params}
  end

  context 'オブジェクトが存在する場合' do
    let(:change_text){"問題例#{rand}"}
    let(:actions) do
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params
    end

    context '完成版の場合' do
      let(:change_draft) {false}

      context '正常に更新できる場合' do

        let(:problem_solving_params) do
          attributes_for(:problem_solving, example_problem: change_text)
        end

        it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
          let(:expected_response_keys){@expected_response_keys}
        end

        it '更新したオブジェクトをレスポンとして返されること' do
          subject
          json = JSON.parse(response.body)
          expect(json['problem_solving']['example_problem']).to eq(change_text)
          expect(json['problem_solving']['actions'].count).to eq(1)
        end

        it 'DBの値が更新されていること' do
          subject
          problem_solving = ProblemSolving.last
          expect(problem_solving.example_problem).to eq(change_text)
          expect(problem_solving.is_draft).to eq(false)

          action = problem_solving.actions.first
          expect(action.evaluation_method).to eq("保存するデータ")
        end

        it 'レコードが生成されていること' do
          expect{ subject }.to change(ProblemSolving, :count).from(0).to(1)
        end

        it 'アクションが生成されていること' do
          expect{ subject }.to change(Action, :count).from(0).to(1)
        end

        it 'タグが生成されていること' do
          expect{ subject }.to change(Tag, :count).from(0).to(2)
        end

        it 'タグ関連付けが生成されていること' do
          expect{ subject }.to change(TagAssociation, :count).from(0).to(2)
        end
      end

      context 'バリデーションエラーの場合' do
        let(:problem_solving_params) do
          attributes_for(:problem_solving, log_date: nil)
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"problem_solving:\tValidation failed: Log date 日付の選択は必須です\n\n"}
        end

        it '新しくレコードが作成されない' do
          expect{ subject }.to change(ProblemSolving, :count).by(0)
        end

      end
    end

    context 'ドラフトの場合' do
      let(:change_draft) {true}

      context '正常に更新できる場合' do
        let(:problem_solving_params) do
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
          problem_solving = ProblemSolving.last
          expect(problem_solving.example_problem).to eq(change_text)
          expect(problem_solving.is_draft).to eq(true)
        end

        it 'レコードが生成されていること' do
          expect{ subject }.to change(ProblemSolving, :count).from(0).to(1)
        end

      end

      context 'バリデーションエラーの場合' do
        let(:problem_solving_params) do
          attributes_for(:problem_solving, log_date: 'abc')
        end

        let(:actions) do
          params = []
          params << attributes_for(:action, evaluation_method:'保存するデータ')
          params
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"problem_solving:\tValidation failed: Log date 日付の選択は必須です\n\n"}
        end

        it '新しくレコードが作成されない' do
          expect{ subject }.to change(ProblemSolving, :count).by(0)
        end
      end

    end
  end

  context 'パラメーターがない場合' do
    let(:change_draft) {nil}

    let(:problem_solving_params) do
      attributes_for(:problem_solving)
    end

    let(:actions) do
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params
    end

    it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
      let(:error_message){"is_draft:\t必須です\n" + "\n"}
    end

  end

  context '保存途中でエラーになった場合' do
    let(:change_draft) {true}
    let(:problem_solving_params) do
      attributes_for(:problem_solving, example_problem: '問題例')
    end

    let(:actions) do
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params
    end

    it 'トランザクション処理のロールバックがかかっていること' do
      allow_any_instance_of(ProblemSolving).to receive(:save_tags!).and_raise(StandardError)
      expect{ subject }.not_to change(ProblemSolving, :count)
    end
  end
end
