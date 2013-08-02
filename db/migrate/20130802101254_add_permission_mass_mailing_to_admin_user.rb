class AddPermissionMassMailingToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :permission_mass_mailing, :boolean
  end
end
