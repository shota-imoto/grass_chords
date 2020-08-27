class AddElementsToChordunit < ActiveRecord::Migration[5.2]
  def change
    add_column :chordunits, :indicator, :string, default: ""
    add_column :chordunits, :repeat, :string, default: ""
    add_column :chordunits, :part, :string, default: ""
  end
end
