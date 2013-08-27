require 'test_helper'

class MessageHelperTest < ActionView::TestCase
  fixtures :messages, :users

  def test_message_unread_by_user?
    user = users(:john)
    assert message_unread_by_user?(messages(:john_message_received_unread), user)
    assert !message_unread_by_user?(messages(:john_message_received_read), user)
    assert !message_unread_by_user?(messages(:john_message_sent), user)
  end

end
