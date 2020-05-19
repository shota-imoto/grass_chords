class ChangeDataNameToKeys < ActiveRecord::Migration[5.2]
  def change
    change_column :keys, :name, :string
  end
end
