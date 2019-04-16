FactoryBot.define do
  factory :action_related_action do
    source { create(:action, :with_parent) }
    target { create(:action, :with_parent) }
  end
end
