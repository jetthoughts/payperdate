class CreateEmailInvitations < ActiveRecord::Migration
  def change
    create_table :email_invitations do |t|
      t.references :user, index: true, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
