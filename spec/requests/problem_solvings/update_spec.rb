require 'rails_helper'

RSpec.describe "ProblemSolvings/update", type: :request do

  before :all do
    @expected_response_keys = ['problem_solving']
  end

  before :each do
    problem_solving = create(:problem_solving, :has_action, is_draft: !change_draft)
    create(:action, problem_solving:problem_solving)
  end

  subject do
    params = save_params
    params[:is_draft] = change_draft
    params[:tag_names_text] = save_tags_names_text
    params[:actions] = actions
    put "/problem_solvings/#{id}", params: {problem_solving: params}
  end

  context 'オブジェクトが存在する場合' do
    let(:id){1}
    let(:change_text){"問題例#{rand}"}
    let(:save_tags_names_text){"タグA,タグB"}

    let(:actions) do

      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
      params
    end

    context '完成版の場合' do
      let(:change_draft) {false}

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
          expect(problem_solving.is_draft).to eq(false)
        end

        it 'タグが生成されていること' do
          expect{ subject }.to change(Tag, :count).from(0).to(2)
        end

        it 'タグ関連付けが生成されていること' do
          expect{ subject }.to change(TagAssociation, :count).from(0).to(2)
        end

        it 'アクションが生成されていること' do
          subject
          update_count = Action.where(evaluation_method: "保存するデータ").count
          expect(update_count).to eq(2)
        end

      end

      context 'バリデーションエラーの場合' do
        let(:save_params) do
          attributes_for(:problem_solving, example_problem: nil, log_date: nil)
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"problem_solving:\tValidation failed: Log date 日付の選択は必須です, Example problem can't be blank\n\n"}
        end

      end
    end

    context 'ドラフトの場合' do
      let(:change_draft) {true}

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

        it 'アクションが生成されていること' do
          subject
          update_count = Action.where(evaluation_method: "保存するデータ").count
          expect(update_count).to eq(2)
        end

      end
    end
  end

  context '保存途中でエラーになった場合' do
    let(:id){1}
    let(:change_draft) {true}
    let(:save_tags_names_text){"タグA,タグB"}
    let(:save_params) do
      attributes_for(:problem_solving, example_problem: '問題例')
    end

    let(:actions) do

      # problem_solvingを生成するときに1件される
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
      params
    end

    it 'トランザクション処理のロールバックがかかっていること' do
      allow_any_instance_of(ProblemSolving).to receive(:save_tags!).and_raise(StandardError)

      subject
      problem_solving = ProblemSolving.find(id)
      expect(problem_solving.example_problem).not_to eq('問題例')
    end

  end

  context 'パラメーターが間違っている場合' do
    let(:actions) do

      # problem_solvingを生成するときに1件される
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
      params
    end

    context 'is_draftがnilの場合' do
      let(:change_draft) {nil}
      let(:id){1}
      let(:save_tags_names_text){"タグA,タグB"}
      let(:save_params) do
        attributes_for(:problem_solving)
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"is_draft:\t必須です\n" + "\n"}
      end

    end

    context 'actionsに関係ないIDが渡された場合' do
      let(:change_draft) {true}
      let(:id){1}
      let(:save_tags_names_text){"タグA,タグB"}
      let(:save_params) do
        attributes_for(:problem_solving)
      end

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
        allow_any_instance_of(ProblemSolving).to receive(:save_tags!).and_raise(StandardError)

        subject
        problem_solving = ProblemSolving.find(id)
        expect(problem_solving.example_problem).not_to eq('問題例')
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"error:	関係ないActionのIDが渡されました\n" + "\n"}
      end

    end

    context 'save_tags_names_textがnilの場合' do
      let(:change_draft) {"hoge"}
      let(:id){1}
      let(:save_tags_names_text){nil}
      let(:save_params) do
        attributes_for(:problem_solving)
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"tag_names_text:	tag_names_textが入力されていません\n\n"}
      end

    end

  end

  it_behaves_like 'オブジェクトが存在しない場合' do
    let(:id){10000000}
    let(:change_draft) {true}
    let(:save_tags_names_text){"タグA,タグB"}
    let(:save_params) do
      attributes_for(:problem_solving, example_problem: '問題例')
    end
    let(:resource_name){'ProblemSolving'}

    let(:actions) do

      # problem_solvingを生成するときに1件される
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
      params
    end
  end

end
