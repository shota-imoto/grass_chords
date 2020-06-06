class AddUserToChords < ActiveRecord::Migration[5.2]
  def change
    add_reference :chords, :user, foreign_key: true
  end
end