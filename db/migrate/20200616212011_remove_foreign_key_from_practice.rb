class RemoveForeignKeyFromPractice < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :practices, column: :song_id
    remove_column :practices, :song_id, :integer
  end
end
