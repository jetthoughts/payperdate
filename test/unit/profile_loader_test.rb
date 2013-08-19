require 'test_helper'
require 'tasks/profile_loader'

class ProfileLoaderTest < ActiveSupport::TestCase
  def setup
    @users = ProfileLoader.load 'test/config/profile_loader_sample_data.yml'
  end

  test 'user with profile should have profile_id set being loaded through profile loader' do
    user = User.find(@users['joe'].id)
    assert user.profile_id, 'user with profile should have profile id'
  end

  test 'user with profile should have profile filled' do
    user = User.find(@users['joe'].id)
    assert user.profile.filled?, 'user with profile should have filled profile'
  end

end
