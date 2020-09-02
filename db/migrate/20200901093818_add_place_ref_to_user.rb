class AddPlaceRefToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :place_id, :integer, null: false, default: 0
  end
end
