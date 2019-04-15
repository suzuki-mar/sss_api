require 'rails_helper'

RSpec.describe Reframing, type: :model do

  describe 'Table Relation' do
    it { should have_many(:tag_associations).dependent(:nullify) }
    it { should have_many(:actions).dependent(:nullify) }
    it { should have_many(:cognitive_distortions).dependent(:nullify) }
  end

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

    describe 'action_plan' do
      it_behaves_like "ドラフトアブルな型" do
        let(:model_name){ :reframing }
        let(:check_column_name){ :action_plan }
      end
    end

    describe 'is_draft' do
      it_behaves_like "is_draftのバリデーション" do
        let(:model){ reframing }
      end
    end

  end

  describe 'save_cognitive!' do

    subject do
      @reframing.save_cognitive!({"cognitive_distortions" => params}, save_context)
    end

    before :each do
      @reframing = create(:reframing)
      @saved_cognitive = @reframing.cognitive_distortions.first
      create(:cognitive_distortion, reframing:@reframing)
      create(:cognitive_distortion)
    end

    context '完成保存' do
      let(:save_context){:completed}
      let(:change_text){"保存するテキスト"}

      context 'パラメーターが正しい場合' do
        let(:params) do
          params = []
          params << {"description" => change_text, "distortion_group" =>"black_and_white_thinking"}
          params << {"id" => @saved_cognitive.id, "description" => change_text, "distortion_group" =>"black_and_white_thinking"}
          params
        end

        it 'idがない場合は新規作成,idがある場合は編集をする' do
          expect{ subject }.to change(CognitiveDistortion, :count). by(0)
        end

        it '全てのパラメーターが更新されていること' do
          subject
          count = CognitiveDistortion.where(description: change_text).count
          expect(count).to eq(2)
        end
      end

      context 'パラメーターが間違っている場合' do
        context 'バリデーションエラー' do
          let(:params) do
            params = []
            params << {"description" =>"MyText", "distortion_group" =>"black_and_white_thinking"}
            params[0]["description"] = nil
            params
          end

          it '例外を発生させること' do
            expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end

        context '関係ないデータを保存使用した場合' do
          let(:params) do

            another_ids = CognitiveDistortion.where.not(reframing_id: @reframing.id).pluck(:id)
            params = []
            params << {"id" => another_ids.first, "description" =>"MyText", "distortion_group" =>"black_and_white_thinking"}
            params
          end

          it '例外を発生させること' do
            expect { subject }.to raise_error(ArgumentError)
          end
        end


      end

    end

    context 'ドラフト保存' do
      let(:save_context){:draft}

      context 'パラメーターが欠けている場合' do
        let(:params) do
          params = []
          params << {"description" => nil, "distortion_group" =>"black_and_white_thinking"}
          params << {"id" => @saved_cognitive.id, "description" => nil, "distortion_group" =>"black_and_white_thinking"}
          params
        end

        it '保存をできていること' do
          expect{ subject }.to change(CognitiveDistortion, :count).by(0)
        end
      end

    end

  end

end