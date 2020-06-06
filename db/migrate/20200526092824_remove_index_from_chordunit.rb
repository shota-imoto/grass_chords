class RemoveIndexFromChordunit < ActiveRecord::Migration[5.2]
  def change
    remove_index :chordunits, :address
  end
end
