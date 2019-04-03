FactoryBot.define do
  factory :tag_association do
    association :tag, factory: :tag
  end
end
