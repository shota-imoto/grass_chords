class RemovePracticeKeyFromPractice < ActiveRecord::Migration[5.2]
  def change
    remove_column :practices, :practice_key, :integer
  end
end
