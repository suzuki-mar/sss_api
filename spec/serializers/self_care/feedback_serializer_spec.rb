require 'rails_helper'

describe SelfCare::FeedbackSerializer, :type => :serializer do

  it "必要な要素が定義されていること" do

    self_care = create(:self_care)
    feedback = SelfCare::Feedback.load_by_self_care(self_care)

    attributes = SelfCare::FeedbackSerializer.new(feedback).attributes
    expect(attributes.keys).to match_array([:is_need_take_care])
  end

end
