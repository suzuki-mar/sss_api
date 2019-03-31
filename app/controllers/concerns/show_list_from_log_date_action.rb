module ShowListFromLogDateAction

  extend ActiveSupport::Concern

  protected

  def recent_list_action(model_class)
    lists = model_class.recent
    render_success_with_list(lists)
  end


end