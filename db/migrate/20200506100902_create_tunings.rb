class CreateTunings < ActiveRecord::Migration[5.2]
  def change
    create_table :tunings do |t|
      t.integer :string_num, null: false
      t.integer :note_name, null: false
      t.references :tuning_all, foreign_key: true
      t.timestamps
    end
  end
end
