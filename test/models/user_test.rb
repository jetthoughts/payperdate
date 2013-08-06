require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users, :messages

  def test_create
    user = User.create! email:    'quux@example.com',
                        password: 'password',
                        nickname: 'quux',
                        name:     'Quux Name'
    assert user.profile
    refute user.profile.filled?
  end

  def test_user_can_send_message
    sender = users(:mia)
    recipient = users(:john)
    sender.messages_sent.create! recipient: recipient, content: 'Hello!'
  end

  def test_user_can_recieve_message
    recipient = users(:john)
    assert_equal 2, recipient.messages_received.count
  end

end
