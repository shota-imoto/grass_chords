class CreatePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :practices do |t|
      t.references :song, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :practice_key
      t.timestamps
    end
  end
end
