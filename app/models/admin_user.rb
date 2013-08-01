class AdminUser < ActiveRecord::Base

  PERMISSIONS = [:permission_approver, :permission_customer_care, :permission_gifts_and_winks, :permission_login_as_user]

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  before_validation :ensure_not_master

  def ensure_not_master
    if master && AdminUser.where('id != ? and master = true', [id]).count > 0
      master = false
    end
  end

  def get_permissions
    permissions = {}
    PERMISSIONS.each do |permission|
      permissions[permission] = send(permission)
    end
    permissions
  end

  def self.available_permissions
    PERMISSIONS
  end

  def master?
    master
  end
end
