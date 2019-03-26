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

      it_behaves_like 'スキーマ通りのオブジェクトを取得できること' do
        let(:expected_response_keys){@expected_response_keys}
      end

      it do
        subject
        expect(response.status).to eq 200
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
            attributes_for(:reframing, feeling: change_text)
          end

          it_behaves_like 'スキーマ通りのオブジェクトを取得できること' do
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
          end

          it do
            subject
            expect(response.status).to eq 200
          end
        end

        context 'バリデーションエラーの場合' do
          let(:reframing_params) do
            attributes_for(:reframing, feeling: nil, log_date: nil)
          end

          it 'バリデーションエラーメッセージを取得できること' do
            subject
            json = JSON.parse(response.body)
            expected_error_message = "reframing:\tValidation failed: Feeling can't be blank, Log date 日付の選択は必須です\n\n"
            expect(json["message"]).to eq(expected_error_message)
          end
        end
      end

      context 'ドラフトの場合' do
        let(:change_draft) {true}

        context '正常に更新できる場合' do
          let(:reframing_params) do
            attributes_for(:reframing, feeling: change_text)
          end

          it_behaves_like 'スキーマ通りのオブジェクトを取得できること' do
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

          it do
            subject
            expect(response.status).to eq 200
          end
        end

        context 'バリデーションエラーの場合' do
          let(:reframing_params) do
            attributes_for(:reframing, before_point: 1000)
          end

          it 'バリデーションエラーメッセージを取得できること' do
            subject
            json = JSON.parse(response.body)
            expected_error_message = "reframing:\tValidation failed: Before point 0から10までしか選択できない\n\n"
            expect(json["message"]).to eq(expected_error_message)
          end
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


end
