class AddReferencesToPractice < ActiveRecord::Migration[5.2]
  def change
    add_reference :practices, :practice_song, foreign_key: true
  end
end

