module DraftableModel
  extend ActiveSupport::Concern

  protected
  def save_draft_with_after_save_block!(params, after_save_block)
    save_params = create_params_of_draftable_save(params)
    save_params[:is_draft] = true
    self.assign_attributes(save_params)
    self.save!(context: :draft)

    after_save_block.call
  end

  def save_complete_with_after_save_block!(params, after_save_block)
    save_params = create_params_of_draftable_save(params)
    save_params[:is_draft] = false

    self.assign_attributes(save_params)
    self.save!(context: :completed)

    after_save_block.call
  end

  private
  def create_params_of_draftable_save(params)
    save_params = {}
    self.attributes.keys.each do |key|
      next if ['id', 'is_draft', 'created_at', 'updated_at'].include?(key)
      save_params[key] = params[key]
    end

    save_params
  end
end
