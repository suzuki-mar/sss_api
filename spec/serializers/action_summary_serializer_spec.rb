require 'rails_helper'

describe ActionSummarySerializer, :type => :serializer do

  it "必要な要素が定義されていること" do

    model = create(:action, :with_parent)
    attributes = ActionSummarySerializer.new(model).attributes
    expected_keys = [:id, :evaluation_method, :execution_method]
    expect(attributes.keys).to match_array(expected_keys)
  end

end
