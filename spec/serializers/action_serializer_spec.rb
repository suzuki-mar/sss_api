require 'rails_helper'

describe ActionSerializer, :type => :serializer do

  describe '必要な要素の確認' do

    context '関連したアクションの設定がない場合' do

      let(:serializer) do
        problem_solving = create(:problem_solving)
        model = create(:action, problem_solving:problem_solving)
        ActionSerializer.new(model)
      end

      it "必要な要素が定義されていること" do
        attributes = serializer.attributes
        expected_keys = [:id, :progress_status_text, :evaluation_method, :execution_method, :due_date, :document]
        expect(attributes.keys).to match_array(expected_keys)
      end

      it 'documentにtypeが設定されていること' do
        attributes = serializer.attributes
        attributes[:document]['type'] = 'problem_solving'
      end
    end

    context '関連したアクションの設定がある場合' do
      before :each do
        first_action = create(:action, :with_parent)
        second_action = create(:action, :with_parent)
        first_action.add_related_action!(second_action)

        Action.set_related_actions_from_loaded_for_targets([first_action])
        @serializer = ActionSerializer.new(first_action)
      end

      it 'related_actionsが設定されている' do
        expect(@serializer.attributes[:related_actions].count).to eq(1)
      end

    end

  end

end