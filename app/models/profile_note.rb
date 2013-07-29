class ProfileNote < ActiveRecord::Base

  belongs_to :profile
  belongs_to :admin_user

  validates :text, presence: true

  default_scope { order('created_at asc') }
end
