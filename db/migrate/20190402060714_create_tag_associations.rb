class CreateTagAssociations < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_associations do |t|
      t.references :tag, foreign_key: true
      t.references :problem_solving, foreign_key: true, null: true
      t.references :reframing, foreign_key: true, null: true

      t.timestamps

    end
  end
end
