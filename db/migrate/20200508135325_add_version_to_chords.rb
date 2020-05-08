class AddVersionToChords < ActiveRecord::Migration[5.2]
  def change
    add_column :chords, :version, :string
  end
end
