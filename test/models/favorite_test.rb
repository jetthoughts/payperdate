require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  fixtures :users, :favorites, :user_settings

  test 'notification about adding to favorite was sent if recipient want to receive them' do
    Delayed::Worker.delay_jobs = false

    john = users(:john)
    mia  = users(:mia)
    assert mia.settings.notify_added_to_favorites?
    assert_difference -> { ActionMailer::Base.deliveries.size }, +1 do
      Favorite.create!(user: john, favorite: mia).committed!
    end

    notification = ActionMailer::Base.deliveries.last
    assert_equal mia.email, notification.to[0]

    Delayed::Worker.delay_jobs = true
  end

  test 'notification about adding to favorite was not sent if recipient want to receive them' do
    Delayed::Worker.delay_jobs = false

    john = users(:john)
    mia  = users(:mia)
    mia.settings.update notify_added_to_favorites: false
    refute mia.settings.notify_added_to_favorites?

    assert_difference -> { ActionMailer::Base.deliveries.size }, 0 do
      Favorite.create!(user: john, favorite: mia).committed!
    end

    Delayed::Worker.delay_jobs = true
  end

end
