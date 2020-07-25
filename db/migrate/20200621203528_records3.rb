class Records3 < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_instruments
    drop_table :instruments
  end
end
