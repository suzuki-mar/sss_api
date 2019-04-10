class CreateActions < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |t|
      t.integer :progress_status, null:false
      t.text :description
      t.date :due_date
      t.date :log_date
      t.boolean :is_draft, null: false
      t.references :problem_solving, foreign_key: true

      t.timestamps
    end
  end
end
