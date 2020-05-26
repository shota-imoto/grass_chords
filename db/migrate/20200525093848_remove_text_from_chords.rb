class RemoveTextFromChords < ActiveRecord::Migration[5.2]
  def change
    remove_column :chords, :text, :text
  end
end
