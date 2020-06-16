class AddPracticeCountToChord < ActiveRecord::Migration[5.2]
  def change
    add_column :chords, :practices_count, :integer, default: 0
  end
end
