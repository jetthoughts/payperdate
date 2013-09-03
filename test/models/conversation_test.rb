require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :messages, :users, :users_dates

  test 'by_user' do
    sophia = users(:sophia)
    lily   = users(:lily)

    assert Conversation.by_user(sophia).count > 0
    assert Conversation.by_user(lily).count == 0

    assert_difference [-> { Conversation.by_user(sophia).count },
                       -> { Conversation.by_user(lily).count }], +1 do
      Message.create sender: lily, recipient: sophia, content: 'Hello'
    end
  end

  test 'by_user does not returns duplicates' do
    john = users(:john)

    assert_nil Conversation.by_user(john).map { |conversation| conversation.interlocutor }.uniq!
  end

  test 'last_message changes on creating messages' do
    john   = users(:john)
    sophia = users(:sophia)
    johns_conversation = Conversation.by_users(john, sophia)
    sophias_conversation = Conversation.by_users(sophia, john)

    new_message = Message.create sender: john, recipient: sophia, content: 'Hello'

    assert_equal new_message, johns_conversation.last_message
    assert_equal new_message, sophias_conversation.last_message
  end

  test 'last_message changes on viewer deletes messages' do
    john                       = users(:john)
    conversation               = Conversation.by_user(john).first
    last_message_before_delete = conversation.last_message

    last_message_before_delete.delete_by(conversation.viewer)

    assert_not_equal last_message_before_delete, conversation.last_message
  end

  test 'last_message not changes on interlocutor deletes messages' do
    john                       = users(:john)
    conversation               = Conversation.by_user(john).first
    last_message_before_delete = conversation.last_message

    last_message_before_delete.delete_by(conversation.interlocutor)

    assert_equal last_message_before_delete, conversation.last_message
  end

  test 'can_be_unlocked? when date locked' do
    users_date   =users_dates(:locked_date_john_lily)
    conversation = Conversation.by_users(users_date.owner, users_date.recipient)
    assert conversation.can_be_unlocked?

    conversation = Conversation.by_users(users_date.recipient, users_date.owner)
    refute conversation.can_be_unlocked?
  end

  test 'can_be_unlocked? when date unlocked' do
    users_date   =users_dates(:unlocked_date_sophia_lily)
    conversation = Conversation.by_users(users_date.owner, users_date.recipient)
    refute conversation.can_be_unlocked?

    conversation = Conversation.by_users(users_date.recipient, users_date.owner)
    refute conversation.can_be_unlocked?
  end

end
