class AddDetailToSong < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :vocal, :boolean, null: false
    add_column :songs, :instrumental, :boolean, null: false
  end
end
