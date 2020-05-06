class CreateFingers < ActiveRecord::Migration[5.2]
  def change
    create_table :fingers do |t|

      t.timestamps
    end
  end
end
