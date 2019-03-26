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


end
