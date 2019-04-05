require 'rails_helper'

describe SelfCareClassification, type: :model do
  describe 'Validation' do 
    describe 'name' do
      it {should validate_presence_of(:name)}
      describe '同じ分類で同じ名前は登録できない' do

        before do
          create(:self_care_classification, status_group: :bad, name:'同じ名前')
        end

        it '同じ名前で同じグループは登録できない' do
          self_care_classification = build(:self_care_classification, status_group: :bad, name:'同じ名前')
          expect(self_care_classification).not_to be_valid
        end

        it '同じ名前だが違うグループは登録できる' do
          self_care_classification = build(:self_care_classification, status_group: :good, name:'同じ名前')
          expect(self_care_classification).to be_valid
        end

      end

    end

    describe 'status_group' do
      it {should validate_presence_of(:status_group)}
    end

  end

  describe 'Enum' do 
    it {should define_enum_for(:status_group).with_values({good: 1, normal: 2, bad: 3}).with_prefix(:status)}
  end
  
  describe 'Table Relation' do 
    it { should have_many(:self_cares).dependent(:nullify) }
  end  
end
