class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :album, null: false
      t.string :image, null: false
      t.integer :verified_status, null: false, default: 0

      t.timestamps
    end
    add_index :photos, :album_id
  end
end
