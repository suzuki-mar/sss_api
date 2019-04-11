require 'rails_helper'

RSpec.describe Action, type: :model do

  describe 'Table Relation' do
    it { should belong_to(:problem_solving ).optional }
    it { should belong_to(:self_care ).optional }
    it { should belong_to(:reframing ).optional }
  end

  describe 'Validation' do
    let(:action){build_stubbed(:action)}

    describe 'progress_status' do
      example 'nullは許可されない' do
        should validate_presence_of(:progress_status)
      end
    end

    describe 'due_date' do
      example 'nullは許可されない' do
        should validate_presence_of(:due_date)
      end
    end

    describe 'evaluation_method' do
      example 'nullは許可されない' do
        should validate_presence_of(:evaluation_method)
      end
    end

    describe 'execution_method' do
      example 'nullは許可されない' do
        should validate_presence_of(:execution_method)
      end
    end

    describe 'document_id' do
      it '作成物に一つだけ設定されている場合はバリデーションにとおる' do
        action.problem_solving_id = 1
        expect(action).to be_valid
      end

      it '作成物に関連付けられていない場合はバリデーションエラーとなる' do
        expect(action).not_to be_valid
      end

      it '作成物に複数関連付けられている場合はバリデーションエラーとなる' do
        action.problem_solving_id = 1
        action.reframing_id = 1
        expect(action).not_to be_valid
      end

    end

  end

  describe 'Enum' do
    it {should define_enum_for(:progress_status).with_values({not_started: 1, doing: 2, done: 3})}
  end


end
