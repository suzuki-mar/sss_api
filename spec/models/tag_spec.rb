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

  describe 'create_from_name_list_if_unexists' do

    before do
      create(:tag, name: "存在するタグ")
    end

    it 'nameリストから存在しないインスタンスを作成できる' do
      Tag.create_from_name_list_if_unexists!(['新しく作成するTag', '存在するタグ'])
      expect(Tag.all.pluck(:name)).to eq(["存在するタグ", '新しく作成するTag'])
    end
  end


end
