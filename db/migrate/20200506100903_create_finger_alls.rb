class CreateFingerAlls < ActiveRecord::Migration[5.2]
  def change
    create_table :finger_alls do |t|
      t.string :name, null: false
      t.references :instrument, foreign_key: true
      t.references :tuning_all, foreign_key: true
      t.timestamps
    end
  end
end
