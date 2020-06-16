class RemoveDetailFromChord < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :chords, column: :artist_id
    remove_foreign_key :chords, column: :album_id
  end
end
