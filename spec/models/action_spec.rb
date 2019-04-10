require 'rails_helper'

RSpec.describe Action, type: :model do

  describe 'Table Relation' do
    it { should belong_to(:problem_solving ) }
  end

  describe 'Validation' do
    let(:action){build_stubbed(:action)}

    describe 'is_draft' do
      it_behaves_like "is_draftのバリデーション" do
        let(:model){ action }
      end
    end

    describe 'progress_status' do
      example 'nullは許可されない' do
        should validate_presence_of(:progress_status)
      end
    end

    describe 'due_date' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :action }
        let(:check_column_name){ :due_date }
      end
    end

    describe 'description' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :action }
        let(:check_column_name){ :description }
      end
    end

    it_behaves_like 'log_dateのバリデーション' do
      let(:model){action}
    end

  end

  describe 'Enum' do
    it {should define_enum_for(:progress_status).with_values({not_started: 1, doing: 2, done: 3})}
  end


end
