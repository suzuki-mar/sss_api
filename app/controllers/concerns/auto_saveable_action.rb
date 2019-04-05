module AutoSaveableAction

  extend ActiveSupport::Concern

  def init_action(model_class)
    model = model_class.new
    raise NotImplementedError.new("initialize!を実装してください") unless model.respond_to?(:initialize!)

    model.initialize!
    render_success_with(model)
  end

  def auto_save_action(model_class)
    raise NotImplementedError.new('インクルード先クラスで指定してください')
  end

  protected
  def auto_save_action?
    (params[:action] == 'auto_save')
  end


end