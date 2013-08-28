require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :messages, :users

  def test_conversations
    sophia = users(:sophia)
    lily   = users(:lily)

    assert Conversation.by_user(sophia).count > 0
    assert Conversation.by_user(lily).count == 0

    assert_difference [-> { Conversation.by_user(sophia).count },
                       -> { Conversation.by_user(lily).count }], +1 do
      Message.create sender: lily, recipient: sophia, content: 'Hello'
    end
  end

  def test_last_message_with
    john   = users(:john)
    sophia = users(:sophia)

    johns_conversation = Conversation.by_users(john, sophia)
    sophias_conversation = Conversation.by_users(sophia, john)

    message = Message.create sender: john, recipient: sophia, content: 'Hello'
    assert_equal message, johns_conversation.last_message
    assert_equal message, sophias_conversation.last_message

    new_message = Message.create sender: sophia, recipient: john, content: 'Hello'
    assert_equal new_message, johns_conversation.last_message
    assert_equal new_message, sophias_conversation.last_message

    new_message.delete_by(john)
    assert_equal message, johns_conversation.last_message
    assert_equal new_message, sophias_conversation.last_message

    new_message.delete_by(sophia)
    assert_equal message, johns_conversation.last_message
    assert_equal message, sophias_conversation.last_message
  end

end
