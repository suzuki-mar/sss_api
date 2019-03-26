class CreateReframings < ActiveRecord::Migration[5.2]
  def change
    create_table :reframings do |t|
      t.date :log_date
      t.text :problem_reason
      t.text :objective_facts
      t.string :feeling
      t.integer :before_point, limit: 1
      t.integer :distortion_group, limit: 1
      t.text :reframing
      t.text :action_plan
      t.integer :after_point, limit: 1
      t.boolean :is_draft

      t.timestamps
    end
  end
end
