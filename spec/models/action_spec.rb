require 'rails_helper'

RSpec.describe Action, type: :model do

  describe 'Table Relation' do
    it { should belong_to(:problem_solving ) }
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

  end

  describe 'Enum' do
    it {should define_enum_for(:progress_status).with_values({not_started: 1, doing: 2, done: 3})}
  end


end
