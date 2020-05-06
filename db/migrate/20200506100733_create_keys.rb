class CreateKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :keys do |t|
      t.integer :name, null: false
      t.boolean :instrumental, null: false
      t.boolean :male, null: false
      t.boolean :female, null: false
      t.references :song, foreign_key: true
      t.timestamps
    end
  end
end