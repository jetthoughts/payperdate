class AddPermissionAccountingToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :permission_accounting, :boolean
  end
end
