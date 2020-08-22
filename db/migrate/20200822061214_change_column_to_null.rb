class ChangeColumnToNull < ActiveRecord::Migration[5.2]
  def up
    change_column_null :users, :image, true
  end

  def down
    change_column_null :users, :image, false
  end
end
