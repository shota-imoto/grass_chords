class AddImageToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :image, :string, null: false
  end
end
