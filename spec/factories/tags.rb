FactoryBot.define do
  factory :tag do
    name { Faker::Color.color_name }
  end
end
