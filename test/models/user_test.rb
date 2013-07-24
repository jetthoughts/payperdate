require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user with profile should have profile_id set' do
    user = User.find(users(:martin).id)
    assert user.profile_id
  end
end
