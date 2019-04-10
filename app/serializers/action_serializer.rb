class ActionSerializer < ActiveModel::Serializer
  attributes :id, :progress_status, :description, :due_date, :log_date, :log_date, :problem_solving_id
end
