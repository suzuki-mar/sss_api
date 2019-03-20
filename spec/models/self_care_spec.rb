require 'rails_helper'

describe SelfCare, :type => :model do
  
  describe 'Validation' do
    let(:self_care){build_stubbed(:self_care)}
    describe 'log_date' do
      example '現在の日付は許可する' do
        self_care.log_date = Date.today
        self_care.validate
        pp self_care.errors.messages
        expect(self_care.errors.messages.count).to be 0
      end 
      example '過去の日付は許可する' do
        self_care.log_date = Date.yesterday
        self_care.validate
        expect(self_care.errors.messages.count).to be 0
      end 
      example '未来の日付は許可されない' do
        self_care.log_date = Date.tomorrow
        self_care.validate
        expect(self_care.errors.messages).to have_key(:log_date)
      end 
      example 'nullは許可されない' do 
        self_care.log_date = nil
        self_care.validate
        expect(self_care.errors.messages).to have_key(:log_date)
      end
    end

    describe 'point' do
      example '0より大きい数で10までの場合は許可する' do
        self_care.point = 0
        self_care.validate
        expect(self_care.errors.messages.count).to be 0
      end 
      example '0より大きい数で10までの場合は許可する' do
        self_care.point = 10
        self_care.validate
        expect(self_care.errors.messages.count).to be 0
      end 
      example '10より大きい数は許可しない' do
        self_care.point = 11
        self_care.validate
        expect(self_care.errors.messages).to have_key(:point)
      end 
      example '正数しか許可しない' do
        self_care.point = -1
        self_care.validate
        expect(self_care.errors.messages).to have_key(:point)
      end 
      example 'nullは許可されない' do 
        self_care.point = nil
        self_care.validate
        expect(self_care.errors.messages).to have_key(:point)
      end
    end

    describe 'reason' do
      example 'nullは許可されない' do
        should validate_presence_of(:reason)
      end 
    end 

    describe 'am_pm' do
      example 'nullは許可されない' do
        should validate_presence_of(:am_pm)
      end
    end

  end

  describe 'Enum' do 
    it {should define_enum_for(:am_pm).with_values({am: 1, pm: 2})}
  end

  describe 'Table Relation' do 
    it { should belong_to(:self_care_classification ) }
  end


end
