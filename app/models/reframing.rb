class Reframing < ApplicationRecord

  include InitailzeableModel
  include HasLogDateModel
  include ActiveModel::Validations
  include DraftableModel
  include HasTagModel
  include DocumentElementModel
  include HasActionsModel
  include SearchFromAllTextColumnModel

  has_many :tag_associations, dependent: :nullify
  has_many :actions, dependent: :nullify
  has_many :cognitive_distortions, dependent: :nullify

  validates :problem_reason, presence: true, on: :completed
  validates :objective_facts, presence: true, on: :completed
  validates :feeling, presence: true, on: :completed
  validates :action_plan, presence: true, on: :completed
  validates :log_date, log_date_type: {initailizeable_model: true }
  validates :before_point, point_type: {initailizeable_model: true }
  validates :after_point, point_type: {initailizeable_model: true }
  validates :is_draft, inclusion: {in: [true, false]}

  # DocumentElementModel用の実装
  def self.includes_related_items
        includes(self.related_column_keys)
  end

  # DocumentElementModel用の実装終わり

  def self.related_column_keys
    [{tag_associations: :tag}, :cognitive_distortions]
  end

  def draftable_save_of_draft!(params)
    save_draft!(params)
    save_tags!(params)
    save_actions!(params)
    save_cognitive!(params, :draft)

    self.reload
  end

  def draftable_save_of_complete!(params)
    save_complete!(params)
    save_tags!(params)
    save_actions!(params)
    save_cognitive!(params, :completed)

    self.reload
  end

  def save_cognitive!(all_params, save_context)
    save_params = all_params['cognitive_distortions']
    edit_cognitive_ids = create_edit_cognitive_ids(save_params)

    # N+1を避けるためIDが存在するものは取得する
    exist_cognitives = CognitiveDistortion.where("#{self.foreign_key_column.to_sym}" => self.id)
    exist_ids = exist_cognitives.pluck(:id)

    #関係ないIDが渡されたら不具合として例外を出す
    edit_cognitive_ids.each do |id|
      raise ::ArgumentError.new("関係ないActionのIDが渡されました") unless exist_ids.include?(id)
    end

    update_cognitives_by_target_and_params!(exist_cognitives, save_params, save_context)
    creates_cognitives_by_params(save_params, save_context)

    delete_target_ids = exist_ids - edit_cognitive_ids
    CognitiveDistortion.where(id: delete_target_ids).destroy_all
  end

  private
  def create_edit_cognitive_ids(params)
    edit_action_ids = params.map do |param|
      param['id']
    end.compact

    edit_action_ids = edit_action_ids.map do |id|
      id.to_i
    end

    edit_action_ids
  end

  def update_cognitives_by_target_and_params!(targets, params, save_context)
    edit_ids = create_edit_cognitive_ids(params)

    edit_targets = targets.select do |target|
      edit_ids.include?(target.id)
    end

    edit_targets.each do |edit_target|

      update_params = params.find do |param|
        next if param['id'].blank?
        param['id'].to_i == edit_target.id
      end

      edit_target.assign_attributes(update_params)
      edit_target.save!(context: save_context)
    end

    true
  end

  def creates_cognitives_by_params(params, save_context)
    params.each do |param|
      next if param['id'].present?

      cognitive = CognitiveDistortion.new
      cognitive.assign_attributes(param)
      cognitive.reframing = self
      cognitive.save!(context: save_context)
    end

  end

  protected
  def initialize_params
    {}
  end

end
