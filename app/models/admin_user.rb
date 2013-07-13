require 'hstore'

class AdminUser < ActiveRecord::Base
  extend HstoreValidator
  include HstoreProperties

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  before_validation :ensure_not_master

  def ensure_not_master
    if master && AdminUser.where('id != ? and master = true', [id]).count > 0
      master = false
    end
  end

  def get_permissions
    permissions || {}
  end

  def self.available_permissions
    [
      { name: 'permissions[approve_photos_avatars]', title: 'Approve photos/avatars' }
    ]
  end
end
