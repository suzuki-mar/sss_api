require 'rails_helper'

RSpec.describe "Reframings", type: :request do
  before :all do
    @expected_response_keys = ['reframing']
  end

  describe 'show' do
    before :each do
      create(:reframing, :has_action, :has_tag, tag_count:3)
    end

    subject do
      get "/reframings/#{id}"
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:resource_name){'Reframing'}
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
        create(:reframing, :has_tag, log_date: date, tag_count:3)
      end

    end

    subject do
      get "/reframings/recent"
    end

    it '直近一週間以内のデータしか取得していない' do
      subject
      json = JSON.parse(response.body)
      expect(json['reframings'].count).to eq(1)
    end

    it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
      let(:expected_response_keys){['reframings', 'start_date', 'end_date']}
    end

  end

  describe 'month' do
    before :each do
      dates = [
          compare_date + 1.month,
          compare_date,
          compare_date - 1.month,
      ]

      dates.each do |date|
        create(:reframing, :has_tag, tag_count:3, log_date: date)
      end

    end

    let(:compare_date){Date.today - 1.month}

    subject do
      get "/reframings/month/#{param_year}/#{param_month}"
    end

    context 'パラメーターが正しい場合' do
      let(:param_year){compare_date.year}
      let(:param_month){compare_date.month}

      it '直近一週間以内のデータしか取得していない' do
        subject
        json = JSON.parse(response.body)
        expect(json['reframings'].count).to eq(1)
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){'reframings'}
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
      post "/reframings/init"
    end

    context '正常に更新できる場合' do

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

      it '初期化したオブジェクトをレスポンスとして返されること' do
        subject
        json = JSON.parse(response.body)
        expect(json['reframing']["is_draft_text"]).to eq("下書き")
      end

      it 'DBの値が更新されていること' do
        subject
        problem_solving = Reframing.last
        expect(problem_solving).not_to be_nil
        expect(problem_solving.is_draft).to be_truthy
      end

    end

  end

end
