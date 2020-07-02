class AddDefaultSongPracticeCountToSong < ActiveRecord::Migration[5.2]
  def change
    change_column :songs, :practice_songs_count, :integer, default: 0 
  end
end

