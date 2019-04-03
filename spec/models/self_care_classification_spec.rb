require 'rails_helper'

describe SelfCareClassification, type: :model do
  describe 'Validation' do 
    describe 'name' do
      example 'nullは許可されない' do
        should validate_presence_of(:name)
      end 
    end 

    describe 'status_group' do
      example 'nullは許可されない' do
        should validate_presence_of(:status_group)
      end
    end
  end

  describe 'Enum' do 
    it {should define_enum_for(:status_group).with_values({good: 1, normal: 2, bad: 3}).with_prefix(:status)}
  end
  
  describe 'Table Relation' do 
    it { should have_many(:self_cares).dependent(:nullify) }
  end  
end
