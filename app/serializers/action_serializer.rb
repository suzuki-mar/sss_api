class ActionSerializer < ActiveModel::Serializer
  attributes :id, :progress_status_text, :evaluation_method, :execution_method, :due_date
  attributes :document

  def progress_status_text

    values = {
        not_started: '未着手',
        doing: '進行中',
        done: '完了',
    }

    values[object.progress_status.to_sym]
  end

  def document

    serailzer_class_name = "#{object.document.class.to_s}Serializer"
    serailzer = serailzer_class_name.constantize.new(object.document)
    attributes = serailzer.attributes
    attributes['type'] = object.document.table_name.singularize
    attributes
  end

end
