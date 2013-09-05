require 'test_helper'

class ProfileViewTest < ActiveSupport::TestCase
  fixtures :users, :user_settings, :profile_views

  test 'notification about adding to favorite was sent if recipient want to receive them' do
    Delayed::Worker.delay_jobs = false

    john = users(:john)
    mia  = users(:mia)
    assert mia.settings.notify_profile_viewed?
    assert_difference -> { ActionMailer::Base.deliveries.size }, +1 do
      ProfileView.create!(user: john, viewed: mia).committed!
    end

    notification = ActionMailer::Base.deliveries.last
    assert_equal mia.email, notification.to[0]

    Delayed::Worker.delay_jobs = true
  end

  test 'notification about adding to favorite was not sent if recipient want to receive them' do
    Delayed::Worker.delay_jobs = false

    john = users(:john)
    mia  = users(:mia)
    mia.settings.update notify_profile_viewed: false
    refute mia.settings.notify_profile_viewed?

    assert_difference -> { ActionMailer::Base.deliveries.size }, 0 do
      ProfileView.create!(user: john, viewed: mia).committed!
    end

    Delayed::Worker.delay_jobs = true
  end

end
