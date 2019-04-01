module DraftableAction

  extend ActiveSupport::Concern

  def draft_save?
    params[:is_draft] == "true"
  end

  def init_action(model_class)
    model = model_class.new
    raise NotImplementedError.new("initialize!を実装してください") unless model.respond_to?(:initialize!)

    model.initialize!
    render_success_with(model)
  end

end