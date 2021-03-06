FactoryBot.define do
  factory :reframing do

    log_date { "2019-03-25" }
    problem_reason { "MyText" }
    objective_facts { "MyText" }
    feeling { "MyString" }
    before_point { 1 }
    action_plan { "MyText" }
    after_point { 1 }
    is_draft { false }

    after(:create) do |reframing|
      reframing.cognitive_distortions << create(:cognitive_distortion, reframing: reframing)
    end

    trait :has_action do
      transient do
        action_text {Faker::Quote.matz}
      end

      after(:create) do |reframing, evaluator|
        create_list(:action, 1, reframing: reframing, evaluation_method:evaluator.action_text, execution_method:evaluator.action_text)
      end
    end

    trait :has_tag do

      transient do
        tag_count {1}
      end

      after(:create) do |reframing, evaluator|
        evaluator.tag_count.times do
          tag = create(:tag)
          create(:tag_association, tag:tag, reframing:reframing)
        end

      end
    end

    trait :set_tag do

      transient do
        target_tag {nil}
      end

      after(:create) do |reframing, evaluator|
        raise ArgumentError.new('target_tagを引数で渡してください') if evaluator.target_tag.nil?
        create(:tag_association, tag:evaluator.target_tag, reframing:reframing)
      end

    end

    trait :draft do
      is_draft { true }
    end

    trait :completed do
      is_draft { false }
    end

  end
end
