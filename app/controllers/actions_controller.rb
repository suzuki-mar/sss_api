class ActionsController < ApiControllerBase

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'Action'
  end

  def param_top_key
    :action
  end

  public
  def doing
    list = Action.only_doing.with_related_document
    render_success_with_list(list)
  end

end