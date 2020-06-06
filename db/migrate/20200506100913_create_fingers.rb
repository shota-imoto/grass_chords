class CreateFingers < ActiveRecord::Migration[5.2]
  def change
    create_table :fingers do |t|
      t.integer :string_num, null: false
      t.integer :fret_num, null: false
      t.references :finger_all, foreign_key: true
      t.timestamps
    end
  end
end
