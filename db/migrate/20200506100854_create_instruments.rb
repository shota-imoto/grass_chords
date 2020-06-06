class CreateInstruments < ActiveRecord::Migration[5.2]
  def change
    create_table :instruments do |t|
      t.string :name, null: false, unique: true
      t.integer :total_string, null: false
      t.timestamps
    end
  end
end
