require 'rails_helper'

describe SelfCare, :type => :model do
  
  describe 'Validation' do
    let(:self_care){build_stubbed(:self_care)}

    it_behaves_like 'log_dateのバリデーション' do
      let(:model){self_care}
    end

    it_behaves_like 'pointのバリデーション' do
      let(:model){build(:self_care)} #update_attributeを使っているのでstubbedは使えない
      let(:attribute_name){:point}
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

  describe 'create_save_params_of_date' do

    it '午前中なら現在の日付とamが生成されること' do

      date_time = DateTime.new(2011, 12, 24, 12, 00, 00)
      params = SelfCare.create_save_params_of_date(date_time)

      param_date = params[:log_date]
      expect(param_date.year).to eq(2011)
      expect(param_date.month).to eq(12)
      expect(param_date.day).to eq(24)

      expect(params[:am_pm]).to eq(:am)
    end

    it '午後なら現在の日付とpmが生成されること' do

      date_time = DateTime.new(2011, 12, 24, 13, 00, 00)
      params = SelfCare.create_save_params_of_date(date_time)

      param_date = params[:log_date]
      expect(param_date.year).to eq(2011)
      expect(param_date.month).to eq(12)
      expect(param_date.day).to eq(24)

      expect(params[:am_pm]).to eq(:pm)
    end


  end

end
