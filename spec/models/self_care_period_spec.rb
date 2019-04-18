require 'rails_helper'

RSpec.describe SelfCarePeriod, type: :model do

  describe 'create_by_self_care' do

    it 'インスタンスの生成' do
      log_date = Date.today

      self_care = create(:self_care, log_date:log_date, am_pm: :pm)
      period = SelfCarePeriod.create_by_self_care(self_care)
      expect(period.log_date).to eq(log_date)
      expect(period.am_pm).to eq(:pm)
    end

  end

  describe 'create_by_log_date_and_am_pm' do

    it 'インスタンスの生成' do
      log_date = Date.today

      self_care = create(:self_care, )
      period = SelfCarePeriod.create_by_log_date_and_am_pm(log_date, :pm)
      expect(period.log_date).to eq(log_date)
      expect(period.am_pm).to eq(:pm)
    end

  end

  describe 'find_forgot_periods_by_confirm_start_date_and_end_date' do

    it '学習の記録をし忘れた日付のperiodを取得することができる' do

      start_date = Date.yesterday
      end_date = Date.today

      create(:self_care, log_date: start_date, am_pm: :am)
      create(:self_care, log_date: end_date, am_pm: :pm)

      range_date = start_date..end_date

      expected = [
          SelfCarePeriod.create_by_log_date_and_am_pm(start_date, :pm),
          SelfCarePeriod.create_by_log_date_and_am_pm(end_date, :am)
      ]

      actual = SelfCarePeriod.find_forgot_periods_by_confirm_range_date(range_date)
      expect(actual).to eq(expected)
    end

  end

end
