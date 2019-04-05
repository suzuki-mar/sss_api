require 'rails_helper'

RSpec.describe DraftableModel, type: :model do

  describe 'save_draft!' do

    it 'ドラフト状態の保存ができる' do

      reframing = create(:reframing, :completed)

      save_params = attributes_for(:reframing)
      save_params[:problem_reason] = nil

      reframing.save_draft!(save_params)

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
