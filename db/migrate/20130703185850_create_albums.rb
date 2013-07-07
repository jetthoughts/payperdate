class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name, null: false
      t.boolean :system, null: false, default: false
      t.references :user, null: false
      t.timestamps
    end
    add_index :albums, :user_id
    add_index :albums, [:name, :user_id], unique: true
  end
end
