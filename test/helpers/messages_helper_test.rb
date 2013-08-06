require 'test_helper'

class MessageHelperTest < ActionView::TestCase
  fixtures :messages, :users

  def test_message_received_by_user?
    user = users(:john)
    assert message_received_by_user?(messages(:john_message_received_read), user)
    assert !message_received_by_user?(messages(:john_message_sent), user)
  end

  def test_message_sent_by_user?
    user = users(:john)
    assert message_sent_by_user?(messages(:john_message_sent), user)
    assert !message_sent_by_user?(messages(:john_message_received_read), user)
  end

  def test_message_unread_by_user?
    user = users(:john)
    assert message_unread_by_user?(messages(:john_message_received_unread), user)
    assert !message_unread_by_user?(messages(:john_message_received_read), user)
    assert !message_unread_by_user?(messages(:john_message_sent), user)
  end

  def test_other_user_of_message
    user = users(:john)
    assert_equal users(:mia), other_user_of_message(messages(:john_message_sent), user)
    assert_equal user, other_user_of_message(messages(:john_message_sent), users(:mia))
  end

end
