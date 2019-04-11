module HasActionsModel

  extend ActiveSupport::Concern

  protected
  def save_actions!(params)
    edit_action_ids = create_edit_action_ids(params['actions'])

    # N+1を避けるためIDが存在するものは取得する
    exist_actions = Action.where("#{self.foreign_key_column.to_sym}" => self.id).includes(self.table_name.singularize.to_sym)

    #関係ないIDが渡されたら不具合として例外を出す
    exist_ids = exist_actions.pluck(:id)
    edit_action_ids.each do |id|
      raise RuntimeError.new("関係ないActionのIDが渡されました") unless exist_ids.include?(id)
    end

    update_action_by_target_and_params(exist_actions, params['actions'])
    creates_by_params(params['actions'])

    delete_target_ids = exist_ids - edit_action_ids
    Action.where(id: delete_target_ids).destroy_all
  end

  private
  def update_action_by_target_and_params(targets, params)
    edit_action_ids = create_edit_action_ids(params)

    edit_actions = targets.select do |action|
      edit_action_ids.include?(action.id)
    end
    edit_actions.each do |action|

      update_params = params.find do |param|
        next if param['id'].blank?
        param['id'].to_i == action.id
      end

      action.assign_attributes(update_params)
      action.save!
    end

    true
  end

  def creates_by_params(params)
    params.each do |params|
      next if params['id'].present?

      action = Action.new
      action.set_document(self)
      action.assign_attributes(params)
      action.save!
    end

  end

  def create_edit_action_ids(params)
    edit_action_ids = params.map do |param|
      param['id']
    end.compact

    edit_action_ids = edit_action_ids.map do |id|
      id.to_i
    end

    edit_action_ids
  end

end