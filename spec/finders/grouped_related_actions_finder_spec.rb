require 'rails_helper'

RSpec.describe GroupedRelatedActionsFinder, type: :finder do

  describe 'fetch_grouped_related_ids_by_action_ids' do
    let!(:first_action){create(:action, :with_parent)}
    let!(:second_action){create(:action, :with_parent)}
    let!(:third_action){create(:action, :with_parent)}

    before :each do
      first_action.add_related_action!(second_action)
      first_action.add_related_action!(third_action)
    end

    it 'アクションIDリストに関連づいているアクションIDをそれぞれ取得する' do

      action_ids = Action.all.pluck(:id)

      expected = {
          first_action.id => [second_action, third_action],
          second_action.id => [first_action],
          third_action.id => [first_action]
      }

      actual = GroupedRelatedActionsFinder.find_by_action_ids(action_ids)

      expect(expected).to eq(actual)
    end

  end


end
