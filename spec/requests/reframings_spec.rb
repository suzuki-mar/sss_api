require 'rails_helper'

RSpec.describe "Reframings", type: :request do
  before :all do
    @expected_response_keys = ['reframing']
  end

  describe 'show' do
    before :each do
      create(:reframing)
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

  describe 'update' do
    before :each do
      create(:reframing, is_draft: !change_draft)
    end

    subject do
      params = {reframing: reframing_params, is_draft: change_draft}
      put "/reframings/#{id}", params: params
    end

    context 'オブジェクトが存在する場合' do
      let(:id){1}
      let(:change_text){"調子がいい#{rand}"}

      context '完成版の場合' do
        let(:change_draft) {false}

        context '正常に更新できる場合' do
          let(:change_text){"調子がいい#{rand}"}

          let(:reframing_params) do
            attributes_for(:reframing, feeling: change_text, distortion_group_number: 2)
          end

          it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
            let(:expected_response_keys){@expected_response_keys}
          end

          it '更新したオブジェクトをレスポンとして返されること' do
            subject
            json = JSON.parse(response.body)
            expect(json['reframing']['feeling']).to eq(change_text)
          end

          it 'DBの値が更新されていること' do
            subject
            reframing = Reframing.find(id)
            expect(reframing.feeling).to eq(change_text)
            expect(reframing.is_draft).to eq(false)
            expect(reframing.distortion_group).to eq('too_general')
          end

        end

        context 'バリデーションエラーの場合' do
          let(:reframing_params) do
            attributes_for(:reframing, feeling: nil, log_date: nil, distortion_group_number: 2)
          end

          it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
            let(:error_message){"reframing:\tValidation failed: Feeling can't be blank, Log date 日付の選択は必須です\n\n"}
          end

        end
      end

      context 'ドラフトの場合' do
        let(:change_draft) {true}

        context '正常に更新できる場合' do
          let(:reframing_params) do
            attributes_for(:reframing, feeling: change_text, distortion_group_number: 2)
          end

          it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
            let(:expected_response_keys){@expected_response_keys}
          end

          it '更新したオブジェクトをレスポンとして返されること' do
            subject
            json = JSON.parse(response.body)
            expect(json['reframing']['feeling']).to eq(change_text)
          end

          it 'DBの値が更新されていること' do
            subject
            reframing = Reframing.find(id)
            expect(reframing.feeling).to eq(change_text)
            expect(reframing.is_draft).to eq(true)
          end

        end

        context 'バリデーションエラーの場合' do
          let(:reframing_params) do
            attributes_for(:reframing, before_point: 1000, distortion_group_number: 2)
          end

          it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
            let(:error_message){"reframing:\tValidation failed: Before point 0から10までしか選択できない\n\n"}
          end

        end
      end
    end

    context 'パラメーターが間違っている場合' do
      context 'is_draftがnilの場合' do
        let(:change_draft) {nil}
        let(:id){1}

        let(:reframing_params) do
          attributes_for(:reframing, distortion_group_number: 2)
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"is_draft:\t必須です\n" + "\n"}
        end
      end

      context 'distortion_group_numberが存在しない値の場合' do
        let(:change_draft) {true}
        let(:id){1}

        let(:reframing_params) do
          attributes_for(:reframing, distortion_group_number: 99999999999)
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"reframings:\t存在しないdistortion_group_numberを指定しました:99999999999\n\n"}
        end
      end

    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:change_draft) {true}
      let(:reframing_params) do
        attributes_for(:reframing, feeling: '調子がいい')
      end
      let(:resource_name){'Reframing'}
    end
  end

  describe 'create' do
    subject do
      params = {reframing: reframing_params, is_draft: change_draft}
      post "/reframings/", params: params
    end

    context 'オブジェクトが存在する場合' do
      let(:change_text){"調子がいい#{rand}"}

      context '完成版の場合' do
        let(:change_draft) {false}

        context '正常に更新できる場合' do
          let(:change_text){"調子がいい#{rand}"}

          let(:reframing_params) do
            attributes_for(:reframing, feeling: change_text, distortion_group_number: 2)
          end

          it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
            let(:expected_response_keys){@expected_response_keys}
          end

          it '更新したオブジェクトをレスポンとして返されること' do
            subject
            json = JSON.parse(response.body)
            expect(json['reframing']['feeling']).to eq(change_text)
          end

          it 'DBの値が更新されていること' do
            subject
            reframing = Reframing.last
            expect(reframing.feeling).to eq(change_text)
            expect(reframing.is_draft).to eq(false)
          end

          it 'レコードが生成されていること' do
            expect{ subject }.to change(Reframing, :count).from(0).to(1)
          end

        end

        context 'バリデーションエラーの場合' do
          let(:reframing_params) do
            attributes_for(:reframing, feeling: nil, log_date: nil, distortion_group_number: 2)
          end

          it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
            let(:error_message){"reframing:\tValidation failed: Feeling can't be blank, Log date 日付の選択は必須です\n\n"}
          end

          it '新しくレコードが作成されない' do
            expect{ subject }.to change(Reframing, :count).by(0)
          end

        end
      end

      context 'ドラフトの場合' do
        let(:change_draft) {true}

        context '正常に更新できる場合' do
          let(:reframing_params) do
            attributes_for(:reframing, feeling: change_text, distortion_group_number: 2)
          end

          it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
            let(:expected_response_keys){@expected_response_keys}
          end

          it '更新したオブジェクトをレスポンとして返されること' do
            subject
            json = JSON.parse(response.body)
            expect(json['reframing']['feeling']).to eq(change_text)
          end

          it 'DBの値が更新されていること' do
            subject
            reframing = Reframing.last
            expect(reframing.feeling).to eq(change_text)
            expect(reframing.is_draft).to eq(true)
          end

          it 'レコードが生成されていること' do
            expect{ subject }.to change(Reframing, :count).from(0).to(1)
          end

        end

        context 'バリデーションエラーの場合' do
          let(:reframing_params) do
            attributes_for(:reframing, before_point: 1000, distortion_group_number: 2)
          end

          it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
            let(:error_message){"reframing:\tValidation failed: Before point 0から10までしか選択できない\n\n"}
          end

          it '新しくレコードが作成されない' do
            expect{ subject }.to change(Reframing, :count).by(0)
          end
        end

      end
    end

    context 'パラメーターがない場合' do
      let(:change_draft) {nil}

      let(:reframing_params) do
        attributes_for(:reframing)
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
        create(:reframing, log_date: date)
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
      let(:expected_response_keys){'reframings'}
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
        create(:reframing, log_date: date)
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

end
