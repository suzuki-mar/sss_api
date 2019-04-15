class CreateCognitiveDistortions < ActiveRecord::Migration[5.2]
  def change
    create_table :cognitive_distortions do |t|
      t.text :description
      t.integer :distortion_group, limit: 1
      t.references :reframing, foreign_key: true
    end

    change_table :reframings do |t|
      t.remove :reframing
      t.remove :distortion_group
    end
  end
end
