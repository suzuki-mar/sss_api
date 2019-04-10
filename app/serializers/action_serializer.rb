class ActionSerializer < ActiveModel::Serializer
  attributes :id, :progress_status_text, :evaluation_method, :execution_method, :due_date

  def progress_status_text

    values = {
        not_started: '未着手',
        doing: '進行中',
        done: '完了',
    }

    values[object.progress_status.to_sym]
  end

end
