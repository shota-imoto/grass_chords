class AddIndexAddressToChordunits < ActiveRecord::Migration[5.2]
  def change
    add_index :chordunits, :address, unique: true
  end
end
