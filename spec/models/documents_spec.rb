require 'rails_helper'

RSpec.describe Documents, type: :model do

  describe 'find_by_log_date_and_type' do
    it '指定したターゲットのドキュメントが存在する' do
      log_date = Date.today
      create(:problem_solving, :has_tag, :has_action, log_date: log_date)
      documents = Documents.find_by_log_date_and_type(log_date, :problem_solving, is_includes_related: false)
      expect(documents.has_type?(:problem_solving)).to be_truthy
      expect(documents.has_type?(:reframing)).to be_falsey
    end

    it 'allの場合は記入した日付のDocumentを全てを取得する' do
      log_date = Date.today
      create(:problem_solving, :has_action, log_date: log_date)
      create(:reframing, :has_action, log_date: log_date)

      documents = Documents.find_by_log_date_and_type(log_date, :all, is_includes_related: false)
      expect(documents.has_type?(:problem_solving)).to be_truthy
      expect(documents.has_type?(:reframing)).to be_truthy
      expect(documents.has_type?(:self_care)).to be_falsey
    end

    it 'Documentが存在しない場合は空のDocumentを取得する' do
      log_date = Date.today
      documents = Documents.find_by_log_date_and_type(log_date, :problem_solving, is_includes_related: false)
      expect(documents.empty?).to be_truthy
    end

    it 'タイプの指定がおかしい場合は例外が発生する' do
      log_date = Date.today
      expect { Documents.find_by_log_date_and_type(log_date, :invalid) }.to raise_error(ArgumentError)
    end
  end

end
