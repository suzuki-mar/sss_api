module DraftableModel
  extend ActiveSupport::Concern

  def save_draft!(params)
    save_params = create_params_of_draftable_save(params)
    save_params[:is_draft] = true

    self.assign_attributes(save_params)
    self.save!(context: :draft)
  end

  def save_complete!(params)
    save_params = create_params_of_draftable_save(params)
    save_params[:is_draft] = false

    self.assign_attributes(save_params)
    self.save!(context: :completed)
  end

  private
  def create_params_of_draftable_save(params)
    save_params = {}

    params.each do |key, value|

      column_name = key.to_s
      next unless self.attributes.keys.include?(column_name)
      next if ['id', 'is_draft', 'created_at', 'updated_at'].include?(column_name)

      save_params[column_name] = value
    end

    save_params
  end
end
