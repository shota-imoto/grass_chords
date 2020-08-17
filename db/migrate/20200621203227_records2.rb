class Records2 < ActiveRecord::Migration[5.2]
  def change
    drop_table :fingers
    drop_table :finger_alls
    drop_table :tunings
    drop_table :tuning_alls
    drop_table :scores
  end
end
