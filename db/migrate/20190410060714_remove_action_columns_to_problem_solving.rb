class RemoveActionColumnsToProblemSolving < ActiveRecord::Migration[5.2]
  def change
    remove_column :problem_solvings, :solution
    remove_column :problem_solvings, :execution_method
    remove_column :problem_solvings, :evaluation_method
  end
end
