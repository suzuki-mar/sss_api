class AddForeignKeySelfCareClassifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :self_cares, :self_care_classification, foreign_key: true
  end
end
