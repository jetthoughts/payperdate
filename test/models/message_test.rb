require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :messages, :users

  def test_create
    Message.create! sender: users(:john), recipient: users(:sophia), content: 'Hello!'
  end

  def test_default_value_of_state
    message = Message.new
    assert message.unread?
  end

  def test_change_state_to_read
    message = messages(:john_message_received_unread)
    message.read!
    assert message.read?
  end

  def test_sender_is_valid
    message = Message.new
    assert message.invalid?
    assert_includes message.errors, :sender

    message.sender_id = -1
    assert message.invalid?
    assert_includes message.errors, :sender
  end

  def test_recipient_is_valid
    message = Message.new
    assert message.invalid?
    assert_includes message.errors, :recipient

    message.recipient_id = -1
    assert message.invalid?
    assert_includes message.errors, :recipient
  end

  def test_content_is_not_empty
    message = Message.new
    assert message.invalid?
    assert_includes message.errors, :content

    message.content = ''
    assert message.invalid?
    assert_includes message.errors, :content
  end

  def test_select_user_messages
    user = users(:john)
    messages = Message.by(user)
    messages.each do |message|
      assert message.sender_id == user.id || message.recipient_id == user.id
    end
  end

  def test_select_unread_messages
    Message.unread.each do |message|
      assert message.unread?
    end
  end

  def test_select_received_messages
    user = users(:john)
    messages = Message.received_by(user)
    messages.each do |message|
      assert message.recipient_id == user.id
    end
  end

  def test_select_sent_messages
    user = users(:john)
    messages = Message.sent_by(user)
    messages.each do |message|
      assert message.sender_id == user.id
    end
  end

end
