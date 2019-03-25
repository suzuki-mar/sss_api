class ReframingSerializer < ActiveModel::Serializer
  attributes :id, :log_date, :problem_reason, :objective_facts, :feeling, :before_point, :distortion_group, :integer, :reframing, :action_plan, :after_point, :is_draft
end
