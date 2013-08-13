require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :messages, :users, :block_relationships

  setup do
    @ria = users(:ria)
    @robert = users(:robert)
  end

  def test_create
    Message.create! sender: users(:john), recipient: users(:sophia), content: 'Hello!'
  end

  def test_default_state
    message = Message.new
    assert message.unread?
    assert message.sent?
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

  def test_change_state_to_deleted_by_sender
    message = messages(:john_message_received_unread)
    message.delete_by_sender!
    assert message.deleted_by_sender?
  end

  def test_change_state_to_deleted_by_recipient
    message = messages(:john_message_received_unread)
    message.delete_by_recipient!
    assert message.deleted_by_recipient?
  end

  def test_deleted_sent_messages_should_not_be_listed
    user = users(:john)
    messages = Message.sent_by(user)
    messages.each do |message|
      assert !message.deleted_by_sender?
    end
  end

  def test_deleted_received_messages_should_not_be_listed
    user = users(:john)
    messages = Message.received_by(user)
    messages.each do |message|
      assert !message.deleted_by_recipient?
    end
  end

  def test_received_by?
    user = users(:john)
    assert messages(:john_message_received_unread).received_by?(user)
    assert !messages(:john_message_sent).received_by?(user)
  end

  def test_sent_by?
    user = users(:john)
    assert messages(:john_message_sent).sent_by?(user)
    assert !messages(:john_message_received_unread).sent_by?(user)
  end

  def test_deleted_by?
    user = users(:john)
    assert messages(:john_message_sent_deleted).deleted_by?(user)
    assert messages(:john_message_received_deleted).deleted_by?(user)
  end

  def test_deleted_messages_should_not_be_listed
    user     = users(:john)
    messages = Message.by(user)
    messages.each do |message|
      assert !message.deleted_by?(user)
    end
  end

  def test_delete_by
    message = messages(:john_message_sent)

    assert !message.deleted_by?(message.sender)
    message.delete_by(message.sender)
    assert message.deleted_by?(message.sender)

    assert !message.deleted_by?(message.recipient)
    message.delete_by(message.recipient)
    assert message.deleted_by?(message.recipient)
  end

  def test_cant_send_message_to_blocker
    message = Message.create sender: @ria, recipient: @robert, content: 'Hello!'
    refute message.valid?
  end

  def test_can_send_message_to_blocked_by_himself
    message = Message.create sender: @robert, recipient: @ria, content: 'Hello!'
    assert message.valid?
  end

end
