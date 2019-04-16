class CreateActionRelatedActions < ActiveRecord::Migration[5.2]
  def change
    create_table :action_related_actions do |t|
      t.references :source, foreign_key: { to_table: :actions }
      t.references :target, foreign_key: { to_table: :actions }

      t.timestamps
    end
  end
end
