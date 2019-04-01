require 'rails_helper'

describe "SelfCareClassification", type: :request do

  before :all do
    @expected_response_keys = ['self_care_classification']
  end

  describe 'update' do
    let(:save_params) do
      params = attributes_for(:self_care_classification, name: change_text)
      params[:status_group_number] = change_number
      params
    end
    let(:change_text){"名前#{rand}"}
    let(:change_number){1}

    let(:option_params) do
      {}
    end

    before :each do
      create(:self_care_classification)
    end

    subject do
      params = {self_care_classification: save_params}
      params[:self_care_classification].merge!(option_params)
      put "/self_care_classifications/#{id}", params: params
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
          expect(json['self_care_classification']['display_name']).to eq("良好:#{change_text}")
        end

        it 'DBの値が更新されていること' do
          subject
          self_care_classification = SelfCareClassification.find(id)
          expect(self_care_classification.name).to eq(change_text)
          expect(self_care_classification.status_group_before_type_cast).to eq(change_number)

        end

      end

      context 'バリデーションエラーの場合' do
        let(:option_params) do
          {name: nil}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"self_care_clasification:	Validation failed: Name can't be blank\n\n"}
        end
      end

    end

    it_behaves_like 'オブジェクトが存在しない場合' do
      let(:id){10000000}
      let(:save_params) do
        attributes_for(:problem_solving, example_problem: '問題例')
      end
      let(:resource_name){'SelfCareClassification'}
    end

    context 'パラメーターが間違っている場合' do
      let(:id){1}
      let(:change_number){10000000}

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"self_care_classification:\t存在しないstatus_group_numberを指定しました:#{change_number}\n" + "\n"}
      end
    end
  end

  describe 'create' do
    let(:save_params) do
      params = attributes_for(:self_care_classification, name: change_text)
      params[:status_group_number] = change_number
      params
    end
    let(:change_text){"名前#{rand}"}
    let(:change_number){1}

    let(:option_params) do
      {}
    end

    before :each do
      create(:self_care_classification)
    end

    subject do
      params = {self_care_classification: save_params}
      params[:self_care_classification].merge!(option_params)
      post "/self_care_classifications", params: params
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
          expect(json['self_care_classification']['status_group']).to eq("良好")
        end

        it 'DBの値が更新されていること' do
          subject
          self_care_classification = SelfCareClassification.last
          expect(self_care_classification.name).to eq(change_text)
          expect(self_care_classification.status_group_before_type_cast).to eq(change_number)

        end

      end

      context 'バリデーションエラーの場合' do
        let(:option_params) do
          {name: nil}
        end

        it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
          let(:error_message){"self_care_clasification:	Validation failed: Name can't be blank\n\n"}
        end
      end

    end


    context 'パラメーターが間違っている場合' do
      let(:id){1}
      let(:change_number){10000000}

      it_behaves_like 'バリデーションパラメーターのエラー制御ができる' do
        let(:error_message){"self_care_classification:\t存在しないstatus_group_numberを指定しました:#{change_number}\n" + "\n"}
      end
    end
  end

  describe 'index' do
    before :each do
      create(:self_care_classification, name: Faker::Color.color_name, status_group: :good)
      create(:self_care_classification, name: Faker::Color.color_name, status_group: :bad)
      create(:self_care_classification, name: Faker::Color.color_name, status_group: :normal)
      create(:self_care_classification, name: Faker::Color.color_name, status_group: :good)
    end

    subject do
      get "/self_care_classifications"
    end

    it 'ソートされたデータを取得できること' do
      subject
      json = JSON.parse(response.body)
      expect(json['self_care_classifications'][0]['status_group']).to eq('良好')
      expect(json['self_care_classifications'][1]['status_group']).to eq('良好')
      expect(json['self_care_classifications'][2]['status_group']).to eq('注意')
      expect(json['self_care_classifications'][3]['status_group']).to eq('悪化')
    end

    it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
      let(:expected_response_keys){'self_care_classifications'}
    end

  end

end
