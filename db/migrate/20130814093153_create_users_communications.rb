class CreateUsersCommunications < ActiveRecord::Migration
  def change
    create_table :users_communications do |t|
      t.integer :owner_id
      t.integer :recipient_id
      t.boolean :unlocked, default: false

      t.timestamps
    end
    add_index :users_communications, [:owner_id, :recipient_id], unique: true
  end
end
