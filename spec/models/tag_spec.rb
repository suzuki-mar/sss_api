require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Validation' do

    describe 'name' do
      it {should validate_uniqueness_of(:name)}
    end

  end

  describe 'Table Relation' do
    it { should have_many(:tag_associations).dependent(:destroy) }
  end

end
