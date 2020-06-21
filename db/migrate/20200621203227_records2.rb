class Records2 < ActiveRecord::Migration[5.2]
  def change
    drop_table :fingers
    drop_table :finger_alls

  end
end
