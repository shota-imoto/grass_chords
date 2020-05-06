class CreateUserInstruments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_instruments do |t|

      t.timestamps
    end
  end
end
