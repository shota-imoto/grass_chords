class Records3 < ActiveRecord::Migration[5.2]
  def change
    drop_table :tuning_alls
    drop_table :scores
    drop_table :instruments
  end
end
