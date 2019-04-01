require 'rails_helper'

RSpec.describe Reframing, type: :model do

  describe 'Validation' do

    let(:reframing){build_stubbed(:reframing)}
    it_behaves_like 'log_dateのバリデーション:initializable' do
      let(:model){reframing}
    end

    it_behaves_like 'pointのバリデーション:initializable' do
      let(:model){build(:reframing)} #update_attributeを使っているのでstubbedは使えない
      let(:attribute_name){:before_point}
    end

    it_behaves_like 'pointのバリデーション:initializable' do
      let(:model){build(:reframing)} #update_attributeを使っているのでstubbedは使えない
      let(:attribute_name){:after_point}
    end

    describe 'problem_reason' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :reframing }
        let(:check_column_name){ :problem_reason }
      end
    end

    describe 'objective_facts' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :reframing }
        let(:check_column_name){ :objective_facts }
      end
    end

    describe 'feeling' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :reframing }
        let(:check_column_name){ :feeling }
      end
    end

    describe 'reframing' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :reframing }
        let(:check_column_name){ :reframing }
      end
    end

    describe 'action_plan' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :reframing }
        let(:check_column_name){ :action_plan }
      end
    end

    describe 'distortion_group' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :reframing }
        let(:check_column_name){ :distortion_group }
      end
    end

    describe 'is_draft' do
      it_behaves_like "is_draftのバリデーション" do
        let(:model){ reframing }
      end
    end

  end

  describe 'Enum' do
    it do
      should define_enum_for(:distortion_group)
                 .with_values({
                                black_and_white_thinking: 1, too_general: 2, heart_filter: 3,
                                negative_thinking: 4, mislead_others_thoughts: 5, extended_interpretation: 6,
                                underestimate: 7, emotional_decision: 8, perfectionism: 9, labeling: 10,
                                shift_responsibility: 11, pessimistic: 12
                              })
    end
  end

  describe 'save_draft!' do

    it 'ドラフト状態の保存ができる' do

      reframing = create(:reframing, :completed)

      reframing.save_draft!({problem_reason: nil})
      expect(reframing.problem_reason).to be_nil
      expect(reframing.is_draft).to be_truthy
    end

  end

  describe 'save_complete!' do

    it '完成状態の保存ができる' do

      reframing = create(:reframing, :draft)
      text = "reason #{rand}"

      params = attributes_for(:reframing, :draft)
      params[:problem_reason] = text
      reframing.save_complete!(params)
      expect(reframing.problem_reason).to eq(text)
      expect(reframing.is_draft).to be_falsey
    end

    it 'パラメーターエラーの場合はエラーとなること' do
      reframing = create(:reframing, :draft)
      params = attributes_for(:reframing, :draft)
      params[:problem_reason] = nil
      params[:before_point] = nil
      expect { reframing.save_complete!(params) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end
