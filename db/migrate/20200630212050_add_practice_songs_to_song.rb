class AddPracticeSongsToSong < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :practice_songs_count, :integer
  end
end

