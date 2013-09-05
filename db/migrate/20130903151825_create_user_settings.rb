class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.references :user, null: false, index: { unique: true }
      t.boolean :notify_invitation_received, null: false, default: true
      t.boolean :notify_invitation_responded, null: false, default: true
      t.boolean :notify_message_received, null: false, default: true
      t.boolean :notify_added_to_favorites, null: false, default: true
      t.boolean :notify_profile_viewed, null: false, default: true

      t.timestamps
    end
  end
end
