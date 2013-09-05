class ProfileView < ActiveRecord::Base
  belongs_to :user
  belongs_to :viewed, class_name: 'User'

  after_commit :notify_viewed, on: :create

  private

  def notify_viewed
    ProfileViewMailer.delay.profile_viewed(self.id)
  end

end
