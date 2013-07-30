class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :message
      t.integer :amount, null: false, default: 0
      t.references :user, null: false
      t.references :invited_user, null: false
      t.boolean :counter, null: false, default: false
      t.string :state, null: false, default: 'pending'
      t.string :reject_reason
      t.timestamps
    end
    add_index :invitations, [:user_id, :counter]
    add_index :invitations, [:invited_user_id, :counter]
  end
end
