require 'rails_helper'

RSpec.describe "ProblemSolvings", type: :request do

  before :all do
    @expected_response_keys = ['problem_solving']
  end

  describe 'show' do
    before :each do
      create(:problem_solving, :has_tag, tag_count: 3)
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

  describe 'recent' do
    before :each do

      dates = [
          Date.today - 7.day,
          Date.today - 8.day,
      ]

      dates.each do |date|
        create(:problem_solving, :has_tag, log_date: date, tag_count: 3)
      end

    end

    subject do
      get "/problem_solvings/recent"
    end

    it '直近一週間以内のデータしか取得していない' do
      subject
      json = JSON.parse(response.body)
      expect(json['problem_solvings'].count).to eq(1)
      start_date = (Date.today - 7.day).to_s(:db)
      expect(json['start_date']).to eq(start_date)
      expect(json['end_date']).to eq(Date.today.to_s(:db))

    end

    it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
      let(:expected_response_keys){['problem_solvings', 'start_date', 'end_date']}
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
        create(:problem_solving,  :has_tag, log_date: date, tag_count: 3)
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

  describe 'init' do

    subject do
      post "/problem_solvings/init"
    end

    context '正常に更新できる場合' do

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

      it '初期化したオブジェクトをレスポンスとして返されること' do
        subject
        json = JSON.parse(response.body)
        expect(json['problem_solving']["is_draft_text"]).to eq("下書き")
      end

      it 'DBの値が更新されていること' do
        subject
        problem_solving = ProblemSolving.last
        expect(problem_solving).not_to be_nil
        expect(problem_solving.is_draft).to be_truthy
        expect(problem_solving.progress_status).to eq("not_started")
      end

    end

  end

  describe 'done' do
    before :each do
      create(:problem_solving, progress_status: :not_started)
    end

    subject do
      put "/problem_solvings/done/#{id}"
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

      it '更新したオブジェクトをレスポンとして返されること' do
        subject
        json = JSON.parse(response.body)
        expect(json['problem_solving']['progress_status_text']).to eq('完了')
      end

      it 'DBの値が更新されていること' do
        subject
        problem_solving = ProblemSolving.find(id)
        expect(problem_solving.progress_status).to eq("done")
      end
    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:resource_name){'ProblemSolving'}
    end
  end

  describe 'doing' do
    before :each do
      create(:problem_solving, progress_status: :not_started)
    end

    subject do
      put "/problem_solvings/doing/#{id}"
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

      it '更新したオブジェクトをレスポンとして返されること' do
        subject
        json = JSON.parse(response.body)
        expect(json['problem_solving']['progress_status_text']).to eq('進行中')
      end

      it 'DBの値が更新されていること' do
        subject
        problem_solving = ProblemSolving.find(id)
        expect(problem_solving.progress_status).to eq("doing")
      end
    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:resource_name){'ProblemSolving'}
    end
  end

  describe 'doings' do
    before :each do
        dates = [
          compare_date,
          compare_date + 1.month,
          compare_date - 1.month,
      ]

      dates.each do |date|
        create(:problem_solving, :has_tag, log_date: date, progress_status: :done, tag_count: 3)
        create(:problem_solving, :has_tag, log_date: date, progress_status: :doing, tag_count: 3)
      end

    end

    let(:compare_date){Date.today - 1.month}

    subject do
      get "/problem_solvings/doings/#{param_year}/#{param_month}"
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

  describe 'dones' do
    before :each do
      dates = [
          compare_date,
          compare_date + 1.month,
          compare_date - 1.month,
      ]

      dates.each do |date|
        create(:problem_solving, :has_tag, log_date: date, progress_status: :done, tag_count: 3)
        create(:problem_solving, :has_tag, log_date: date, progress_status: :not_started, tag_count: 3)
      end

    end

    let(:compare_date){Date.today - 1.month}

    subject do
      get "/problem_solvings/dones/#{param_year}/#{param_month}"
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
