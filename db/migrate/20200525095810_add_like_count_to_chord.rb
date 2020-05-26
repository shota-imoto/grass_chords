class AddLikeCountToChord < ActiveRecord::Migration[5.2]
  def change
    add_column :chords, :likes_count, :integer, default: 0
  end
end
