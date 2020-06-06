class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :title, null: false
      t.boolean :jam, null: false
      t.boolean :standard, null: false
      t.boolean :beginner, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
