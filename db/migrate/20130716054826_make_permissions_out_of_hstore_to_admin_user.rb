class MakePermissionsOutOfHstoreToAdminUser < ActiveRecord::Migration
  def change
  	add_column :admin_users, :permission_approve_photos_avatars, :boolean
  	remove_column :admin_users, :permissions
  end
end
