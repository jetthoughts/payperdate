require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users, :messages, :block_relationships, :users_communications


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

  def test_user_can_receive_message
    recipient = users(:john)
    sender = users(:mia)
    assert_difference -> { recipient.messages_received.count }, +1 do
      sender.messages_sent.create! recipient: recipient, content: 'Hello!'
    end
  end

  def test_block_user
    users(:john).block_user(users(:mia))
    assert users(:mia).blocked_for? users(:john)
  end

  def test_blocked_for
    refute users(:mia).blocked_for? users(:john)
    assert users(:ria).blocked_for? users(:robert)
  end

  def test_unblock_user
    users(:robert).unblock_user users(:ria)
    refute users(:ria).blocked_for? users(:robert)
    # check if unblock user just deletes relation, but not target user
    assert User.find(users(:ria).id)
  end

  def test_can_communicated_with
    paul = users(:paul)
    lily = users(:lily)
    john =  users(:john)
    users_communications(:unlocked_communications_john_paul)
    assert paul.can_communicated_with?(john)
    assert john.can_communicated_with?(paul)

    refute john.can_communicated_with?(lily)
  end

  def test_delete_user
    users(:john).delete!
    assert_equal 'deleted_by_himself', users(:john).deleted_state
  end

end
