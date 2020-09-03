class CreateMessage < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :text, null: false
      t.references :to_user, foreign_key: {to_table: :users}
      t.references :from_user, foreign_key: {to_table: :users}
    end
  end
end
