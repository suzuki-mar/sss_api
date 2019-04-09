require 'rails_helper'

describe "SelfCareCahrts", type: :request do

  before :all do
    @expected_response_keys = ['self_care']
  end

  describe 'log_date_line_graph' do
    before :each do
      dates = [
          compare_base_date + 1.month,
          compare_base_date - 1.month,
      ]

      self_care_classification = create(:self_care_classification)

      dates.each do |date|
        create(:self_care, log_date: date, self_care_classification:self_care_classification)
      end

      @start_date = compare_base_date.beginning_of_month
      @end_date = compare_base_date.end_of_month

      points = []
      @end_date.day.downto(1) do |day|
        date = Date.new(@start_date.year, @start_date.month, day)
        points << rand(10)

        create(:self_care, log_date: date, point:points.last, self_care_classification:self_care_classification, am_pm: :am)
        create(:self_care, log_date: date, point:points.last, self_care_classification:self_care_classification, am_pm: :pm)
      end

    end

    let(:compare_base_date){Date.today - 1.month}

    subject do
      get "/self_cares/log_date_line_graph/#{param_year}/#{param_month}"
    end

    context 'パラメーターが正しい場合' do
      let(:param_year){compare_base_date.year}
      let(:param_month){compare_base_date.month}

      it '生成されている期間をデータで表示している' do
        subject
        json = JSON.parse(response.body)
        expect(json['date_value_line_graph_items'].count).to eq(@end_date.day * 2)

        actual_date = Date.parse(json['date_value_line_graph_items'][0]['date'])
        expect(actual_date).to eq(@start_date)
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){["date_value_line_graph_items", "end_date", "start_date"]}
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

  describe 'point_pie_chart' do
    before :each do
      dates = [
          compare_base_date + 1.month,
          compare_base_date - 1.month,
      ]

      good_classification = create(:self_care_classification, status_group: :good)
      normal_classification = create(:self_care_classification, status_group: :normal)
      bad_classification = create(:self_care_classification, status_group: :bad)

      dates.each do |date|
        create(:self_care, log_date: date, self_care_classification:good_classification)
      end

      @start_date = compare_base_date.beginning_of_month

      1.upto(4) do |day|
        date = Date.new(@start_date.year, @start_date.month, day)
        point = rand(10)

        if day % 2 == 0
          create(:self_care, log_date: date, point:point, self_care_classification:bad_classification, am_pm: :pm)
        else
          create(:self_care, log_date: date, point:point, self_care_classification:normal_classification, am_pm: :am)
          create(:self_care, log_date: date, point:point, self_care_classification:bad_classification, am_pm: :pm)
        end
      end

    end

    let(:compare_base_date){Date.today - 1.month}

    subject do
      get "/self_cares/point_pie_chart/#{param_year}/#{param_month}"
    end

    context 'パラメーターが正しい場合' do
      let(:param_year){compare_base_date.year}
      let(:param_month){compare_base_date.month}

      it '生成されている期間をデータで表示している' do
        subject
        json = JSON.parse(response.body)

        item_json = json["pie_chart_items"]
        expect(item_json[0]).to eq({"percentage"=>0.0, "name"=>"良好", "value"=>0})
        expect(item_json[1]).to eq({"percentage"=>33.33333333333333, "name"=>"注意", "value"=>2})
        expect(item_json[2]).to eq({"percentage"=>66.66666666666666, "name"=>"悪化", "value"=>4})
      end

      it_behaves_like 'スキーマ通りのオブジェクトを取得できてレスポンスが正しいことること' do
        let(:expected_response_keys){["pie_chart_items", "end_date", "start_date"]}
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
