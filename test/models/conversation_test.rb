require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :messages, :users

  def test_by_user
    sophia = users(:sophia)
    lily   = users(:lily)

    assert Conversation.by_user(sophia).count > 0
    assert Conversation.by_user(lily).count == 0

    assert_difference [-> { Conversation.by_user(sophia).count },
                       -> { Conversation.by_user(lily).count }], +1 do
      Message.create sender: lily, recipient: sophia, content: 'Hello'
    end
  end

  def test_by_user_does_not_returns_duplicates
    john = users(:john)

    assert_nil Conversation.by_user(john).map { |conversation| conversation.interlocutor }.uniq!
  end

  def test_last_message_changes_on_creating_messages
    john   = users(:john)
    sophia = users(:sophia)
    johns_conversation = Conversation.by_users(john, sophia)
    sophias_conversation = Conversation.by_users(sophia, john)

    new_message = Message.create sender: john, recipient: sophia, content: 'Hello'

    assert_equal new_message, johns_conversation.last_message
    assert_equal new_message, sophias_conversation.last_message
  end

  def test_last_message_changes_on_viewer_deletes_messages
    john                       = users(:john)
    conversation               = Conversation.by_user(john).first
    last_message_before_delete = conversation.last_message

    last_message_before_delete.delete_by(conversation.viewer)

    assert_not_equal last_message_before_delete, conversation.last_message
  end

  def test_last_message_not_changes_on_interlocutor_deletes_messages
    john                       = users(:john)
    conversation               = Conversation.by_user(john).first
    last_message_before_delete = conversation.last_message

    last_message_before_delete.delete_by(conversation.interlocutor)

    puts conversation.messages.to_yaml
    puts conversation.last_message.to_yaml

    assert_equal last_message_before_delete, conversation.last_message
  end

end
