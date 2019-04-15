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

    let(:cognitive_distortion){create(:cognitive_distortion, :with_parent, distortion_group: :extended_interpretation)}
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

      let(:reframing){create(:reframing)}
      it '同じレコードが存在しない場合は保存できる' do
        cognitive_distortion = build(:cognitive_distortion, reframing:reframing, distortion_group: :too_general)
        expect(cognitive_distortion).to be_valid

        #
        # pp cognitive_distortion
        # exit


        # create(:cognitive_distortion, reframing:reframing, distortion_group: :black_and_white_thinking)
        # pp CognitiveDistortion.all

        # exit

      end


    end



  end

  describe 'distortion_group' do

    it_behaves_like "ドラフトアブルな型" do
      let(:model_name){ :cognitive_distortion }
      let(:check_column_name){ :distortion_group }
    end

    let(:reframing){create(:reframing)}
    it '同じレコードが存在しない場合は保存できる' do
      cognitive_distortion = build(:cognitive_distortion, reframing:reframing, distortion_group: :too_general)
      expect(cognitive_distortion).to be_valid
    end

    it '同じレコードが存在しない場合は保存できる' do
      distortion_group = reframing.cognitive_distortions.first.distortion_group
      cognitive_distortion = build(:cognitive_distortion, reframing:reframing, distortion_group: distortion_group)
      expect(cognitive_distortion).not_to be_valid
    end

  end

  describe 'unregistered_distortion_group_key' do

    it '登録していないkeyを取得できる' do

      reframing = create(:reframing)
      exists_distortion_group = reframing.cognitive_distortions.first.distortion_group

      keys = CognitiveDistortion.unregistered_distortion_group_key_by_reframing_id(reframing.id)
      expect(keys.include?(exists_distortion_group)).not_to be_truthy

    end



  end




end
