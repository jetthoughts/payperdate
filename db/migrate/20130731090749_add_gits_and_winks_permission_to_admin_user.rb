class AddGitsAndWinksPermissionToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :permission_gifts_and_winks, :boolean
  end
end
