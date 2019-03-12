class CreateSelfCares < ActiveRecord::Migration[5.2]
  def change
    create_table :self_cares do |t|
      t.date :log_date, null: false
      t.integer :am_pm, limit: 1, null: false
      t.integer :status_group, limit: 1, null: false
      t.integer :point, limit: 1, null: false
      t.text :reason, null: false
      t.timestamps
    end
  end
end
