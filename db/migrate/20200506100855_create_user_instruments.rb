class CreateUserInstruments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_instruments do |t|
      t.references :user, foreign_key: true
      t.references :instrument, foreign_key: true
      t.integer :default_inst
      t.timestamps
    end
  end
end
