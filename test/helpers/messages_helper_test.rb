require 'test_helper'

class MessageHelperTest < ActionView::TestCase
  fixtures :messages, :users

  def test_message_unread_by_user?
    user = users(:john)
    assert message_unread_by_user?(messages(:mia_john_unread), user)
    assert !message_unread_by_user?(messages(:sophia_john_read), user)
    assert !message_unread_by_user?(messages(:john_mia_unread), user)
  end

end
