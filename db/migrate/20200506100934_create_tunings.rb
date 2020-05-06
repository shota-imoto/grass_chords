class CreateTunings < ActiveRecord::Migration[5.2]
  def change
    create_table :tunings do |t|

      t.timestamps
    end
  end
end
