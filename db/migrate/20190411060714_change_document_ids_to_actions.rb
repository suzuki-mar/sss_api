class ChangeDocumentIdsToActions < ActiveRecord::Migration[5.2]
  def change
    add_reference :actions, :self_care, foreign_key: true, null: true
    add_reference :actions, :reframing, foreign_key: true, null: true
    change_column_null :actions, :problem_solving_id, true
  end
end
