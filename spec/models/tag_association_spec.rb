require 'rails_helper'

RSpec.describe TagAssociation, type: :model do

  describe 'Validation' do

    describe 'document_id' do
      let(:tag_association) do
        tag_association = build(:tag_association)
      end

      it '作成物に一つだけ設定されている場合はバリデーションにとおる' do
        tag_association.problem_solving_id = 1
        expect(tag_association).to be_valid
      end

      it '作成物に関連付けられていない場合はバリデーションエラーとなる' do
        expect(tag_association).not_to be_valid
      end

      it '作成物に複数関連付けられている場合はバリデーションエラーとなる' do
        tag_association.problem_solving_id = 1
        tag_association.reframing_id = 1
        expect(tag_association).not_to be_valid
      end

    end

  end

  describe 'Table Relation' do
    it { should belong_to(:tag ) }
    it { should belong_to(:problem_solving ).optional }
    it { should belong_to(:reframing ).optional }

  end

end