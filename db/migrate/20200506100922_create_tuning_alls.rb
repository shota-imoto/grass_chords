class CreateTuningAlls < ActiveRecord::Migration[5.2]
  def change
    create_table :tuning_alls do |t|

      t.timestamps
    end
  end
end
