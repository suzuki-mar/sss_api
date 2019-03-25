class CreateProblemSolvings < ActiveRecord::Migration[5.2]
  def change
    create_table :problem_solvings do |t|
      t.date :log_date
      t.boolean :is_draft
      t.text :problem_recognition
      t.text :example_problem

      t.timestamps
    end
  end
end
