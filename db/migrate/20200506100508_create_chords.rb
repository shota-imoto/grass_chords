class CreateChords < ActiveRecord::Migration[5.2]
  def change
    create_table :chords do |t|
      t.references :song, foreign_key: true
      t.references :artist, foreign_key: true
      t.references :album, foreign_key: true
      t.text :text, null: false, unique: true
      t.timestamps
    end
  end
end
