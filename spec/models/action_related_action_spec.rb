require 'rails_helper'

RSpec.describe ActionRelatedAction, type: :model do
  describe 'Table Relation' do
    it { should belong_to(:source) }
    it { should belong_to(:target) }
  end

  describe 'Validation' do

    describe 'source_idとtarget_idの組み合わせ' do

      it 'source_idとtatget_idの組み合わせがない場合はバリデーションエラーにならない' do
        related = create(:action_related_action)
        expect(related).to be_valid
      end

      it 'source_idとtatget_idの同じ組み合わせがある場合はバリデーションエラーになる' do
        related = create(:action_related_action)
        check_model = build(:action_related_action, source:related.source, target:related.target)
        expect(check_model).not_to be_valid
      end

      it 'soruce_idが同じでもtaget_idが違う場合は登録することができる' do
        related = create(:action_related_action)
        new_action = create(:action, :with_parent)
        check_model = build(:action_related_action, source:related.source, target:new_action)
        expect(check_model).to be_valid
      end

      it 'source_idとtarget_idが逆になっていても同じ組み合わせとして扱いバリデーションエラーになる' do
        related = create(:action_related_action)
        check_model = build(:action_related_action, source:related.target, target:related.source)
        expect(check_model).not_to be_valid
      end

      it 'source_idとtatget_idが同じ場合はバリデーションエラーになる' do
        new_action = create(:action, :with_parent)
        check_model = build(:action_related_action, source:new_action, target:new_action)
        expect(check_model).not_to be_valid
      end
    end

    describe 'source_idとtarget_idが同じものは登録できない' do

      it 'source_idとtatget_idの組み合わせが違う場合はバリデーションエラーにならない' do
        related = create(:action_related_action)
        expect(related).to be_valid
      end

      it 'source_idとtatget_idの同じ組み合わせがある場合はバリデーションエラーになる' do
        related = create(:action_related_action)
        check_model = build(:action_related_action, source:related.source, target:related.source)
        expect(check_model).not_to be_valid
      end

    end

  end

  describe 'has_already_relation_registered?' do
    let!(:source_action){create(:action, :with_parent)}
    let!(:target_action){create(:action, :with_parent)}

    it '関連が登録されている場合はtrueが帰る' do
      target_action.add_related_action!(source_action)
      actual = ActionRelatedAction.has_already_relation_registered(source_action, target_action)
      expect(actual).to be_truthy
    end

    it '関連が登録されていない場合はfalseが帰る' do
      actual = ActionRelatedAction.has_already_relation_registered(source_action, target_action)
      expect(actual).to be_falsey
    end

  end

end
