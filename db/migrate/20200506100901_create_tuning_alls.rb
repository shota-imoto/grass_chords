class CreateTuningAlls < ActiveRecord::Migration[5.2]
  def change
    create_table :tuning_alls do |t|
      t.string :name, null: false
      t.references :instrument, foreign_key: true
      t.timestamps
    end
  end
end
