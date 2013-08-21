require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  fixtures :users, :invitations, :ranks

  setup do
    Delayed::Worker.delay_jobs = false
  end

  test 'deleted users on index should be marked as deleted' do
    users(:martin).delete!
    sign_in(users(:mia))
    get :index
    assert_response :success
    assert_select 'span', 'Deleted'
  end

  test 'deleted users on sent should be marked as deleted' do
    users(:mia).delete!
    sign_in(users(:martin))
    get :sent
    assert_response :success
    assert_select 'span', 'Deleted'
  end

  def test_can_accept_invitations
    sign_in users(:lily)
    invitation = invitations(:paul_lily_not_accepted)
    assert_difference [-> { invitation.recipient.messages_sent.count },
                       -> { invitation.inviter.messages_received.count }], +1 do
      post :accept, id: invitation, message: 'Sample message'
      assert_redirected_to accepted_invitations_path
    end
  end

  def test_can_accept_invitations_without_message
    sign_in users(:lily)
    invitation = invitations(:paul_lily_not_accepted)
    assert_difference [-> { invitation.recipient.messages_sent.count },
                       -> { invitation.inviter.messages_received.count }], 0 do
      post :accept, id: invitation
      assert_redirected_to accepted_invitations_path
    end
  end

  def test_can_accept_countered_invitations
    sign_in users(:lily)
    invitation = invitations(:lily_john_countered)
    assert_difference [-> { invitation.recipient.messages_sent.count },
                       -> { invitation.inviter.messages_received.count }], +1 do
      post :accept, id: invitation, message: 'Sample message'
      assert_redirected_to accepted_invitations_path
    end
  end

end
