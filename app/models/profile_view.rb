class ProfileView < ActiveRecord::Base
  belongs_to :user
  belongs_to :viewed
end
