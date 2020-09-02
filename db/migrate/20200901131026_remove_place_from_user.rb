class RemovePlaceFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :place, :string
  end
end
