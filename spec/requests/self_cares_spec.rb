require 'rails_helper'

describe "SelfCares", type: :request do

  before :all do
    @expected_response_keys = ['self_care']
  end

  describe 'show' do
    before :each do
      create(:self_care)
    end

    subject do
      get "/self_cares/#{id}"
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:resource_name){'SelfCare'}
      let(:request_method_type){:get}
    end
  end

  describe 'update' do
    let(:classification_name){"新しく作成した分類名"}
    let(:save_params) do
      attributes_for(:self_care, reason: change_text, self_care_classification_id: self_care_classification_id)
    end
    let(:self_care_classification_id){@self_care_classification_id}
    let(:change_text){"理由#{rand}"}

    let(:option_params) do
      {}
    end

    before :each do
      create(:self_care)
      self_care_classification = create(:self_care_classification, name: classification_name)
      @self_care_classification_id = self_care_classification.id
    end

    subject do
      params = {self_care: save_params}
      params[:self_care].merge!(option_params)
      put "/self_cares/#{id}", params: params
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}

      context '正常に更新できる場合' do

        it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
          let(:expected_response_keys){@expected_response_keys}
        end

        it '更新したオブジェクトをレスポンとして返されること' do
          subject
          json = JSON.parse(response.body)
          expect(json['self_care']['reason']).to eq(change_text)
          expect(json['self_care']['classification_name']).to eq("悪化:#{classification_name}")
        end

        it 'DBの値が更新されていること' do
          subject
          self_care = SelfCare.find(id)
          expect(self_care.reason).to eq(change_text)
          expect(self_care.self_care_classification.name).to eq(classification_name)
        end

      end

      context 'バリデーションエラーの場合' do
        let(:option_params) do
          {log_date: nil}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"self_care:\tValidation failed: Log date 日付の選択は必須です\n\n"}
        end
      end

    end

    context 'パラメーターが間違っている場合' do
      let(:id){1}
      let(:self_care_classification_id){99999999999999}

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"self_care_classification:\t存在しないIDを渡しました#{self_care_classification_id}\n" + "\n"}
      end
    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:change_draft) {true}
      let(:save_params) do
        attributes_for(:problem_solving, example_problem: '問題例')
      end
      let(:resource_name){'SelfCare'}
    end
  end

  describe 'create' do
    let(:classification_name){"新しく作成した分類名"}
    let(:save_params) do
      attributes_for(:self_care, reason: change_text, self_care_classification_id: self_care_classification_id)
    end
    let(:self_care_classification_id){@self_care_classification_id}
    let(:change_text){"理由#{rand}"}

    let(:option_params) do
      {}
    end

    before :each do
      self_care_classification = create(:self_care_classification, name: classification_name)
      @self_care_classification_id = self_care_classification.id
    end

    subject do
      params = {self_care: save_params}
      params[:self_care].merge!(option_params)
      post "/self_cares", params: params
    end

    context '正常に更新できる場合' do

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

      it '更新したオブジェクトをレスポンとして返されること' do
        subject
        json = JSON.parse(response.body)
        expect(json['self_care']['reason']).to eq(change_text)
        expect(json['self_care']['classification_name']).to eq("悪化:#{classification_name}")
      end

      it 'DBの値が更新されていること' do
        subject
        self_care = SelfCare.last
        expect(self_care.reason).to eq(change_text)
        expect(self_care.self_care_classification.name).to eq(classification_name)
      end

    end

    context 'バリデーションエラーの場合' do
      let(:option_params) do
        {log_date: nil}
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"self_care:\tValidation failed: Log date 日付の選択は必須です\n\n"}
      end
    end

    context 'パラメーターが間違っている場合' do
      let(:id){1}
      let(:self_care_classification_id){99999999999999}

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"self_care_classification:\t存在しないIDを渡しました#{self_care_classification_id}\n" + "\n"}
      end
    end
  end

  describe 'recent' do
    before :each do

      dates = [
          Date.today - 7.day,
          Date.today - 8.day,
      ]

      self_care_classification = create(:self_care_classification)

      dates.each do |date|
        create(:self_care, log_date: date, self_care_classification: self_care_classification)
      end

    end

    subject do
      get "/self_cares/recent"
    end

    it '直近一週間以内のデータしか取得していない' do
      subject
      json = JSON.parse(response.body)
      expect(json['self_cares'].count).to eq(1)
    end

    it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
      let(:expected_response_keys){['self_cares', 'start_date', 'end_date']}
    end

  end

  describe 'month' do
    before :each do
      dates = [
          compare_date,
          compare_date + 1.month,
          compare_date - 1.month,
      ]

      self_care_classification = create(:self_care_classification)

      dates.each do |date|
        create(:self_care, log_date: date, self_care_classification:self_care_classification)
      end

    end

    let(:compare_date){Date.today - 1.month}

    subject do
      get "/self_cares/month/#{param_year}/#{param_month}"
    end

    context 'パラメーターが正しい場合' do
      let(:param_year){compare_date.year}
      let(:param_month){compare_date.month}

      it '直近一週間以内のデータしか取得していない' do
        subject
        json = JSON.parse(response.body)
        expect(json['self_cares'].count).to eq(1)
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){'self_cares'}
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

  describe 'current_create' do
    let(:classification_name){"新しく作成した分類名"}
    let(:save_params) do
      attributes_for(:self_care, reason: change_text, self_care_classification_id: self_care_classification_id)
    end
    let(:self_care_classification_id){@self_care_classification_id}
    let(:change_text){"理由#{rand}"}

    let(:option_params) do
      {}
    end

    before :each do
      self_care_classification = create(:self_care_classification, name: classification_name)
      @self_care_classification_id = self_care_classification.id
    end

    subject do

      params = {self_care: save_params}
      params[:self_care].merge!(option_params)
      params[:self_care].delete(:am_pm)
      params[:self_care].delete(:log_date)
      post "/self_cares/current", params: params
    end

    context '正常に更新できる場合' do

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){@expected_response_keys}
      end

      it '更新したオブジェクトをレスポンとして返されること' do
        subject
        json = JSON.parse(response.body)
        expect(json['self_care']['reason']).to eq(change_text)
        expect(json['self_care']['classification_name']).to eq("悪化:#{classification_name}")
      end

      it 'DBの値が更新されていること' do
        subject
        self_care = SelfCare.last
        expect(self_care.reason).to eq(change_text)
        expect(self_care.self_care_classification.name).to eq(classification_name)
        expect(self_care.log_date == Date.today).to be_truthy
      end

    end

    context 'バリデーションエラーの場合' do
      let(:option_params) do
        {point: nil}
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"self_care:\tValidation failed: Point ポイントの選択は必須です\n\n"}
      end
    end

    context 'パラメーターが間違っている場合' do
      let(:self_care_classification_id){99999999999999}

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"self_care_classification:\t存在しないIDを渡しました#{self_care_classification_id}\n" + "\n"}
      end
    end
  end
end
