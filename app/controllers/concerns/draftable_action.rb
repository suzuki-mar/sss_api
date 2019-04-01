module DraftableAction

  extend ActiveSupport::Concern

  def draft_save?
    params[:is_draft] == "true"
  end

  def init_action(model_class)
    model = ProblemSolving.new
    model.initialize!
    render_success_with(model)
  end

end