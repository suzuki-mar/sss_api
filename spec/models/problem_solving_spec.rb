require 'rails_helper'

RSpec.describe ProblemSolving, type: :model do
  describe 'Validation' do

    let(:problem_solving){build_stubbed(:problem_solving)}
    it_behaves_like 'log_dateのバリデーション' do
      let(:model){problem_solving}
    end

    describe 'problem_recognition' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :problem_solving }
        let(:check_column_name){ :problem_recognition }
      end
    end

    describe 'example_problem' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :problem_solving }
        let(:check_column_name){ :example_problem }
      end
    end

    describe 'cause' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :problem_solving }
        let(:check_column_name){ :cause }
      end
    end

    describe 'phenomenon' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :problem_solving }
        let(:check_column_name){ :phenomenon }
      end
    end

    describe 'neglect_phenomenon' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :problem_solving }
        let(:check_column_name){ :neglect_phenomenon }
      end
    end

    describe 'solution' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :problem_solving }
        let(:check_column_name){ :solution }
      end
    end

    describe 'execution_method' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :problem_solving }
        let(:check_column_name){ :execution_method }
      end
    end

    describe 'evaluation_method' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :problem_solving }
        let(:check_column_name){ :evaluation_method }
      end
    end

    describe 'is_draft' do
      it_behaves_like "is_draftのバリデーション" do
        let(:model){ problem_solving }
      end
    end

    describe 'progress_status' do
      example 'nullは許可されない' do
        should validate_presence_of(:progress_status)
      end
    end

    describe 'Enum' do
      it {should define_enum_for(:progress_status).with_values({not_started: 1, doing: 2, done: 3})}
    end


  end
end
