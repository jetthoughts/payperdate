class ProfileView < ActiveRecord::Base
  belongs_to :user
  belongs_to :viewed, class_name: 'User'
end
