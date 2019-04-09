class AddSelfCareIdToTagAssociations < ActiveRecord::Migration[5.2]
  def change
    add_reference :tag_associations, :self_care, foreign_key: true, null: true
  end
end
