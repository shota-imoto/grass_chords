class AddKeyToChord < ActiveRecord::Migration[5.2]
  def change
    add_column :chords, :key, :string, null: false, default: "G"
  end
end
