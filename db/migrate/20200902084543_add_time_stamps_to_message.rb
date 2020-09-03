class AddTimeStampsToMessage < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :messages, null: false
  end
end
