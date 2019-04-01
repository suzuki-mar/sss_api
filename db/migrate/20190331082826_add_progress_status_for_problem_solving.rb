class AddProgressStatusForProblemSolving < ActiveRecord::Migration[5.2]
  def change
    add_column :problem_solvings, :progress_status, :integer, limit: 1, null: false, default: 1
  end
end
