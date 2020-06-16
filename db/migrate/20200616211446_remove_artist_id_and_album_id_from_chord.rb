class RemoveArtistIdAndAlbumIdFromChord < ActiveRecord::Migration[5.2]
  def change
    remove_column :chords, :artist_id, :integer
    remove_column :chords, :album_id, :integer
  end
end
