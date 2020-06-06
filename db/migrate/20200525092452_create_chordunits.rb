class CreateChordunits < ActiveRecord::Migration[5.2]
  def change
    create_table :chordunits do |t|
      t.integer :address, null: false
      t.text :text
      t.string :leftbar
      t.string :rightbar
      t.string :beat
      t.references :chord, foreign_key: true

      t.timestamps
    end
  end
end
