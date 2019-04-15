FactoryBot.define do
  factory :cognitive_distortion do
    description { "MyText" }
    distortion_group do
      if reframing.present?
        group_keys = CognitiveDistortion.unregistered_distortion_group_key_by_reframing_id(reframing.id)
        group_keys.sample
      # reframingがない場合は未作成として扱う
      else
        :too_general
      end
    end

    reframing {create(:reframing)}

    trait :with_not_parent do
      reframing {nil}
    end

  end
end
