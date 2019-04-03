require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Validation' do

    describe 'name' do
      it {should validate_uniqueness_of(:name)}
      it '文字列は許可する' do
        should allow_value('a').for(:name)
      end
      it '空白は許可しない' do
        should_not allow_value('').for(:name)
      end
    end

  end

  describe 'Table Relation' do
    it { should have_many(:tag_associations).dependent(:destroy) }
  end

end
