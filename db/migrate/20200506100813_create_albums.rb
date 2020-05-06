class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|

      t.timestamps
    end
  end
end
