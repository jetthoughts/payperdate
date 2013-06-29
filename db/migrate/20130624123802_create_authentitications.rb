class CreateAuthentitications < ActiveRecord::Migration
  def change
    create_table :authentitications do |t|
      t.string :provider, null: false
      t.integer :user_id, null: false
      t.string :uid, null: false
      t.string :access_token
      t.timestamps
    end
    add_index :authentitications, [:user_id, :provider], unique: true
    add_index :authentitications, [:provider, :uid], unique: true
  end
end
