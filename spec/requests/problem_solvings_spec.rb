require 'rails_helper'

RSpec.describe "ProblemSolvings", type: :request do

  before :all do
    @expected_response_keys = ['problem_solving']
  end

  describe 'show' do
    before :each do
      create(:problem_solving)
    end

    subject do
      get "/problem_solvings/#{id}"
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:resource_name){'ProblemSolving'}
      let(:request_method_type){:get}
    end
  end

  describe 'update' do
    before :each do
      create(:problem_solving, is_draft: !change_draft)
    end

    subject do
      params = {problem_solving: save_params, is_draft: change_draft}
      put "/problem_solvings/#{id}", params: params
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}
      let(:change_text){"問題例#{rand}"}

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

        end

        context 'バリデーションエラーの場合' do
          let(:save_params) do
            attributes_for(:problem_solving, log_date: 1000)
          end

          it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
            let(:error_message){"problem_solving:\tValidation failed: Log date 日付の選択は必須です\n\n"}
          end

        end
      end
    end

    context 'パラメーターが間違っている場合' do
      context 'is_draftがnilの場合' do
        let(:change_draft) {nil}
        let(:id){1}

        let(:save_params) do
          attributes_for(:problem_solving)
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"is_draft:\t必須です\n" + "\n"}
        end
      end

    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:change_draft) {true}
      let(:save_params) do
        attributes_for(:problem_solving, example_problem: '問題例')
      end
      let(:resource_name){'ProblemSolving'}
    end
  end

  describe 'create' do
    subject do
      params = {problem_solving: problem_solving_params, is_draft: change_draft}
      post "/problem_solvings/", params: params
    end

    context 'オブジェクトが存在する場合' do
      let(:change_text){"問題例#{rand}"}

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
          end

          it 'DBの値が更新されていること' do
            subject
            problem_solving = ProblemSolving.last
            expect(problem_solving.example_problem).to eq(change_text)
            expect(problem_solving.is_draft).to eq(false)
          end

          it 'レコードが生成されていること' do
            expect{ subject }.to change(ProblemSolving, :count).from(0).to(1)
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

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"is_draft:\t必須です\n" + "\n"}
      end

    end
  end

  describe 'recent' do
    before :each do

      dates = [
          Date.today - 7.day,
          Date.today - 8.day,
      ]

      dates.each do |date|
        create(:problem_solving, log_date: date)
      end

    end

    subject do
      get "/problem_solvings/recent"
    end

    it '直近一週間以内のデータしか取得していない' do
      subject
      json = JSON.parse(response.body)
      expect(json['problem_solvings'].count).to eq(1)
    end

    it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
      let(:expected_response_keys){'problem_solvings'}
    end

  end

  describe 'month' do
    before :each do
      dates = [
          compare_date,
          compare_date + 1.month,
          compare_date - 1.month,
      ]

      dates.each do |date|
        create(:problem_solving, log_date: date)
      end

    end

    let(:compare_date){Date.today - 1.month}

    subject do
      get "/problem_solvings/month/#{param_year}/#{param_month}"
    end

    context 'パラメーターが正しい場合' do
      let(:param_year){compare_date.year}
      let(:param_month){compare_date.month}

      it '直近一週間以内のデータしか取得していない' do
        subject
        json = JSON.parse(response.body)
        expect(json['problem_solvings'].count).to eq(1)
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){'problem_solvings'}
      end
    end

    context 'パラメーターが間違っている場合' do
      let(:param_year){1999}
      let(:param_month){13}

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"month:\t月の指定がおかしいです:渡した月:13\n" + "\n"}
      end

    end

  end



end
