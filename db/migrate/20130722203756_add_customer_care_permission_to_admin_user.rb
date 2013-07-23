class AddCustomerCarePermissionToAdminUser < ActiveRecord::Migration
  def change
    rename_column :admin_users, :permission_approve_photos_avatars, :permission_approver
    add_column :admin_users, :permission_customer_care, :boolean
  end
end
