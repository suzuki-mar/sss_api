require 'rails_helper'

RSpec.describe CognitiveDistortion, type: :model do

  describe 'Table Relation' do
    it { should belong_to(:reframing ) }
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

  describe 'Validation' do

    let(:cognitive_distortion){create(:cognitive_distortion, :with_parent)}
    describe 'description' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :cognitive_distortion }

        let(:check_column_name){ :description }
      end
    end

    describe 'distortion_group' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :cognitive_distortion }
        let(:check_column_name){ :distortion_group }
      end
    end

  end
end
