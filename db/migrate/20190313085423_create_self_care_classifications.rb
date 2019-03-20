class CreateSelfCareClassifications < ActiveRecord::Migration[5.2]
  def change
    create_table :self_care_classifications do |t|
      t.integer :status_group, limit: 1, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
