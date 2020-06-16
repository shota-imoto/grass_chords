class AddReferencesToPractices < ActiveRecord::Migration[5.2]
  def change
    add_reference :practices, :chord, foreign_key: true
  end
end
