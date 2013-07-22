class AddPermissionsToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :permissions, :hstore
    add_column :admin_users, :master, :boolean
  end
end
