class RemoveReferencesFromPracticeSong < ActiveRecord::Migration[5.2]
  def change
    # remove_foreign_key :practice_songs, :practices
    remove_reference :practice_songs, :practice
  end
end

