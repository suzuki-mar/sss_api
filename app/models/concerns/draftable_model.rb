module DraftableModel
  extend ActiveSupport::Concern

  def save_draft!(params)
    params[:is_draft] = true
    self.assign_attributes(params)
    self.save!(context: :draft)
  end

  def save_complete!(params)
    params[:is_draft] = false
    self.assign_attributes(params)
    self.save!(context: :completed)
  end

end
