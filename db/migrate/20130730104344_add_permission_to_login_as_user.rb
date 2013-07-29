class AddPermissionToLoginAsUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :permission_login_as_user, :boolean, null: false, default: false
  end
end
