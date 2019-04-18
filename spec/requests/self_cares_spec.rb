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

  describe 'recently_forgot_period' do
    before :each do
      create(:self_care, log_date: Date.yesterday, am_pm: :am)
      create(:self_care, log_date: Date.yesterday, am_pm: :pm)
    end

    subject do
      get '/self_cares/recently_forgot_period'
    end

    context '2日以内で記録をつけていない日数を取得する' do
      it 'レスポンスを取得できている' do
        subject
        json = JSON.parse(response.body)['self_care_periods']

        # 時刻によって個数が違う
        expect(json.count).to be > 3
      end
    end

  end

  describe 'update' do
    let(:classification_name){"新しく作成した分類名"}
    let(:save_params) do
      params = attributes_for(:self_care, reason: change_text, self_care_classification_id: self_care_classification_id)
      params.merge!(option_params)
      params
    end
    let(:self_care_classification_id){@self_care_classification_id}
    let(:change_text){"理由#{rand}"}

    let(:option_params) do
      {}
    end

    before :each do
      create(:self_care, :has_action)
      self_care_classification = create(:self_care_classification, name: classification_name)
      @self_care_classification_id = self_care_classification.id
    end

    subject do
      save_params.merge!(option_params)
      save_params[:actions] = actions
      put "/self_cares/#{id}", params: {self_care: save_params}
    end

    let(:actions) do
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
      params
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}

      let(:option_params) do
        {tag_names_text: 'タグA,タグB'}
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
          expect(json['self_care']['actions'].count).to eq(2)
        end

        it 'DBの値が更新されていること' do
          subject
          self_care = SelfCare.find(id)
          expect(self_care.reason).to eq(change_text)
          expect(self_care.self_care_classification.name).to eq(classification_name)

          action_count = self_care.actions.where(evaluation_method: "保存するデータ").count
          expect(action_count).to eq(2)
        end

        it 'タグが生成されていること' do
          expect{ subject }.to change(Tag, :count).from(0).to(2)
        end

        it 'タグ関連付けが生成されていること' do
          expect{ subject }.to change(TagAssociation, :count).from(0).to(2)
        end
      end

      context 'バリデーションエラーの場合' do
        let(:option_params) do
          {log_date: nil, tag_names_text: 'タグA,タグB'}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"self_care:\tValidation failed: Log date 日付の選択は必須です\n\n"}
        end
      end

    end

    context 'パラメーターが間違っている場合' do
      let(:id){1}
      let(:self_care_classification_id){99999999999999}
      let(:option_params) do
        {tag_names_text: 'タグA,タグB'}
      end

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"self_care_classification:\t存在しないIDを渡しました#{self_care_classification_id}\n" + "\n"}
      end
    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:option_params) do
        {tag_names_text: 'タグA,タグB'}
      end
      let(:save_params) do
        attributes_for(:problem_solving, example_problem: '問題例')
      end
      let(:resource_name){'SelfCare'}
    end

    context '保存エラーの場合' do
      let(:id){1}
      let(:self_care_classification_id){1}
      let(:option_params) do
        {tag_names_text: 'タグA,タグB'}
      end

      context 'タグ保存で失敗した場合' do
        it 'トランザクション処理のロールバックがかかっていること' do
          allow_any_instance_of(SelfCare).to receive(:save_tags!).and_raise(StandardError)
          subject
          self_care = SelfCare.find(id)
          expect(self_care.reason).not_to eq(change_text)
        end
      end

      context 'アクション保存に失敗した場合' do
        let(:actions) do
          problem_solving = create(:problem_solving, :has_action)
          another_action = Action.where(problem_solving_id: problem_solving.id).first

          # self_careを生成するときに1件される
          params = []
          params << attributes_for(:action, evaluation_method:'保存するデータ')
          params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
          params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: another_action.id})
          params
        end

        it 'トランザクション処理のロールバックがかかっていること' do
          subject
          self_care = SelfCare.find(id)
          expect(self_care.reason).not_to eq(change_text)
        end
      end

    end
  end

  describe 'create' do
    let(:classification_name){"新しく作成した分類名"}
    let(:save_params) do
      attributes_for(:self_care, reason: change_text,
                     self_care_classification_id: self_care_classification_id,
                     tag_names_text: 'タグA,タグB')
    end
    let(:self_care_classification_id){@self_care_classification_id}
    let(:change_text){"理由#{rand}"}

    let(:option_params) do
      {}
    end

    let(:actions) do
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params
    end

    before :each do
      self_care_classification = create(:self_care_classification, name: classification_name)
      @self_care_classification_id = self_care_classification.id
    end

    subject do
      save_params.merge!(option_params)
      save_params[:actions] = actions
      post "/self_cares", params: {self_care: save_params}
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
        expect(json['self_care']['tags'].count).to eq(2)
        expect(json['self_care']['actions'].count).to eq(1)
      end

      it 'DBの値が更新されていること' do
        subject
        self_care = SelfCare.last
        expect(self_care.reason).to eq(change_text)
        expect(self_care.self_care_classification.name).to eq(classification_name)

        action_count = self_care.actions.where(evaluation_method: "保存するデータ").count
        expect(action_count).to eq(1)

      end

      it 'タグが生成されていること' do
        expect{ subject }.to change(Tag, :count).from(0).to(2)
      end

      it 'タグ関連付けが生成されていること' do
        expect{ subject }.to change(TagAssociation, :count).from(0).to(2)
      end

    end

    context 'バリデーションエラーの場合' do
      context '記録日がnilの場合' do
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

      context '存在しない分類IDを渡した' do

        let(:self_care_classification_id){99999999999999}

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"self_care_classification:\t存在しないIDを渡しました#{self_care_classification_id}\n" + "\n"}
        end
      end

      context 'tag_names_textがnilの場合' do
        let(:option_params) do
          {tag_names_text: nil}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"tag_names_text:	tag_names_textが入力されていません\n\n"}
        end
      end
    end

    context '保存エラーの場合' do
      let(:self_care_classification_id){1}
      let(:option_params) do
        {tag_names_text: 'タグA,タグB'}
      end

      context 'タグ保存で失敗した場合' do
        it 'トランザクション処理のロールバックがかかっていること' do
          allow_any_instance_of(SelfCare).to receive(:save_tags!).and_raise(StandardError)
          subject
          expect{ subject }.to change(SelfCare, :count).by(0)
        end
      end

      context 'アクション保存に失敗した場合' do
        let(:actions) do
          problem_solving = create(:problem_solving, :has_action)
          another_action = Action.where(problem_solving_id: problem_solving.id).first

          # self_careを生成するときに1件される
          params = []
          params << attributes_for(:action, evaluation_method:'保存するデータ')
          params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
          params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: another_action.id})
          params
        end

        it 'トランザクション処理のロールバックがかかっていること' do
          subject
          expect{ subject }.to change(SelfCare, :count).by(0)
        end
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

  describe 'recored_now' do
    let(:compare_date){Date.today - 1.month}

    subject do
      get "/self_cares/recored_now"
    end

    context '現時刻のデータを記録してある場合' do
      before :each do
        create(:self_care, :current_log)
      end

      it 'trueがかえること' do
        subject
        json = JSON.parse(response.body)
        expect(json['is_recorded_now']).to be_truthy
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){'is_recorded_now'}
      end
    end

    context '現時刻のデータを記録していない場合' do
      it 'falseがかえること' do
        subject
        json = JSON.parse(response.body)
        expect(json['is_recorded_now']).to be_falsey
      end

    end

  end

  describe 'current_create' do
    let(:classification_name){"新しく作成した分類名"}
    let(:save_params) do
      params = attributes_for(:self_care, reason: change_text, self_care_classification_id: self_care_classification_id)
      params[:tag_names_text] = tag_names_text
      params
    end
    let(:self_care_classification_id){@self_care_classification_id}
    let(:change_text){"理由#{rand}"}
    let(:tag_names_text){"タグA,タグB"}

    let(:option_params) do
      {}
    end

    let(:actions) do
      params = []
      params << attributes_for(:action, evaluation_method:'保存するデータ')
      params
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
      params[:self_care][:actions] = actions
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
        expect(json['self_care']['tags'].count).to eq(2)
        expect(json['self_care']['actions'].count).to eq(1)
      end

      it 'DBの値が更新されていること' do
        subject
        self_care = SelfCare.last
        expect(self_care.reason).to eq(change_text)
        expect(self_care.self_care_classification.name).to eq(classification_name)
        expect(self_care.log_date == Date.today).to be_truthy

        action = self_care.actions.first
        expect(action.evaluation_method).to eq("保存するデータ")
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

    context '保存エラーの場合' do
      let(:self_care_classification_id){1}
      let(:option_params) do
        {tag_names_text: 'タグA,タグB'}
      end

      context 'タグ保存で失敗した場合' do
        it 'トランザクション処理のロールバックがかかっていること' do
          allow_any_instance_of(SelfCare).to receive(:save_tags!).and_raise(StandardError)
          subject
          expect{ subject }.to change(SelfCare, :count).by(0)
        end
      end

      context 'アクション保存に失敗した場合' do
        let(:actions) do
          problem_solving = create(:problem_solving, :has_action)
          another_action = Action.where(problem_solving_id: problem_solving.id).first

          # self_careを生成するときに1件される
          params = []
          params << attributes_for(:action, evaluation_method:'保存するデータ')
          params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: Action.first.id})
          params << attributes_for(:action, evaluation_method:'保存するデータ').merge({id: another_action.id})
          params
        end

        it 'トランザクション処理のロールバックがかかっていること' do
          subject
          expect{ subject }.to change(SelfCare, :count).by(0)
        end
      end

    end
  end
end
