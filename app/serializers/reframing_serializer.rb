class ReframingSerializer < ActiveModel::Serializer
  include Common::DraftSerializer
  include Common::HasTagSerializer

  has_many :actions

  attributes :id, :log_date, :problem_reason, :objective_facts, :feeling, :before_point,
             :action_plan, :after_point, :is_draft_text, :tags, :cognitive_distortions

  def cognitive_distortions
    object.cognitive_distortions.map do |cognitive|
      CognitiveDistortionSerializer.new(cognitive).attributes
    end
  end

end
