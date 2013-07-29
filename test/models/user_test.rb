require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  def test_create
    user = User.create! email:    'quux@example.com',
                        password: 'password',
                        nickname: 'quux',
                        name:     'Quux Name'
    assert user.profile
    refute user.profile.filled?
  end
  
  test 'user with profile should have profile_id set' do
    user = User.find(users(:martin).id)
    assert user.profile_id
  end
end
