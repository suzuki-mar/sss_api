FactoryBot.define do
  factory :self_care_classification do
    status_group {:bad}

    sequence :name do |n|
      "#{Faker::Games::Zelda.item}-#{n}"
    end
  end
end
