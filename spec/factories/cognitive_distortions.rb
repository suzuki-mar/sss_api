FactoryBot.define do
  factory :cognitive_distortion do
    description { "MyText" }
    distortion_group { :black_and_white_thinking }
    reframing {create(:reframing)}

    trait :with_not_parent do
      reframing {nil}
    end

  end
end
