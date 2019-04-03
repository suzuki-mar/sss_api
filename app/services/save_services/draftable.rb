class SaveServices::Draftable
  def save_draft!(target_model, params)
    params[:is_draft] = true
    target_model.assign_attributes(params)
    target_model.save!(context: :draft)
  end

  def save_complete!(target_model, params)
    params[:is_draft] = false
    target_model.assign_attributes(params)
    target_model.save!(context: :completed)
  end

end
