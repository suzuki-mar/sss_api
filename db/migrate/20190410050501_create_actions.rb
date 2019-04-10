class CreateActions < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |t|
      t.integer :progress_status, null:false
      t.text :evaluation_method, null:false
      t.text :execution_method, null:false
      t.date :due_date, null:false
      t.references :problem_solving, foreign_key: true

      t.timestamps
    end
  end
end
