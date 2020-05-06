class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.text :image, null: false
      t.integer :chord_num, null: false
      t.references :song, foreign_key: true
      t.timestamps
    end
  end
end
