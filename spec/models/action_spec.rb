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

  describe 'find_ids_by_tag_name' do
    let(:search_tag){create(:tag, name:'検索するタグ')}
    let(:problem_solving){create(:problem_solving, :set_tag, :has_action,  target_tag: search_tag, action_text:'検索するテキスト')}
    let(:reframing){create(:reframing, :set_tag, :has_action, target_tag: search_tag, action_text:'検索するテキスト')}

    before :each do
      another_tag = create(:tag, name:'検索しないタグ')
      create(:self_care, :set_tag, :has_action, target_tag: another_tag, action_text:'検索しないテキスト')

      create(:problem_solving, :set_tag, target_tag: search_tag)
    end

    it '指定したタグ名を持っているドキュメントに属しているアクションIDのリストを取得できる' do
      expected = (problem_solving.actions.pluck(:id) + reframing.actions.pluck(:id))
      expect(Action.find_ids_by_tag_name(search_tag.name)).to eq(expected)
    end

  end

  describe 'find_ids_by_text' do
    let(:search_target_text){"検索ターゲット#{rand}"}

    let(:problem_solving){create(:problem_solving, :has_action,  action_text:'検索するテキスト', problem_recognition:search_target_text)}
    let(:self_care){create(:self_care, :has_action, action_text:'検索するテキスト', reason:search_target_text)}

    before :each do
      create(:reframing, :has_action, action_text:'検索しないテキスト')
    end

    it '指定したタグ名を持っているドキュメントに属しているアクションIDのリストを取得できる' do
      expected = (problem_solving.actions.pluck(:id) + self_care.actions.pluck(:id))
      expect(Action.find_ids_by_parent_text(search_target_text)).to eq(expected)
    end

  end
end
