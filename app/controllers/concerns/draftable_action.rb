module DraftableAction

  extend ActiveSupport::Concern

  def draft_save?
    params[:is_draft] == "true"
  end

end