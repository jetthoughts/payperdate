class RenamePermissionGiftsAndWinksToPermissionGiftsWinksDatesInAdminUser < ActiveRecord::Migration
  def change
    rename_column :admin_users, :permission_gifts_and_winks, :permission_gifts_winks_dates
  end
end
