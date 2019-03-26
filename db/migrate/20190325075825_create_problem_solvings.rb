class CreateProblemSolvings < ActiveRecord::Migration[5.2]
  def change
    create_table :problem_solvings do |t|
      t.date :log_date
      t.boolean :is_draft, null: false
      t.text :problem_recognition
      t.text :example_problem
      t.text :cause
      t.text :phenomenon
      t.text :neglect_phenomenon
      t.text :solution
      t.text :execution_method
      t.text :evaluation_method

      t.timestamps
    end
  end
end
