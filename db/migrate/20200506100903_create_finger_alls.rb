class CreateFingerAlls < ActiveRecord::Migration[5.2]
  def change
    create_table :finger_alls do |t|

      t.timestamps
    end
  end
end
