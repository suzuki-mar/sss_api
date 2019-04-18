require 'rails_helper'

describe SelfCarePeriodSerializer, :type => :serializer do

  describe '必要な要素の確認' do

    it "必要な要素が定義されていること" do

      model = SelfCarePeriod.create_by_log_date_and_am_pm(Date.today, :am)
      attributes = SelfCarePeriodSerializer.new(model).attributes
      expected_keys = [:am_pm, :log_date]
      expect(attributes.keys).to match_array(expected_keys)
    end

  end

end