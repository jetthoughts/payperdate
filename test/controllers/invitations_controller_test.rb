require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  fixtures :users, :invitations

  setup do
    @current_user              = users(:lily)
    sign_in @current_user
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

  def test_index
    get :index
    assert_response :success
    invitations = assigns(:invitations)
    assert invitations.include?(invitations(:paul_lily_not_accepted))
    assert invitations.include?(invitations(:lily_john_countered))
    refute invitations.include?(invitations(:lily_paul_not_accepted))
  end

  def test_sent
    get :sent
    assert_response :success
    invitations = assigns(:invitations)
    refute invitations.include?(invitations(:paul_lily_not_accepted))
    refute invitations.include?(invitations(:lily_john_countered))
    assert invitations.include?(invitations(:lily_paul_not_accepted))
  end

  def test_rejected
    invitation = invitations(:paul_lily_not_accepted)
    get :rejected
    assert_response :success
    refute assigns(:invitations).include?(invitation)

    invitation.reject_by_reason('some reason')
    get :rejected
    assert_response :success
    assert assigns(:invitations).include?(invitation)
  end

  def test_accepted
    invitation = invitations(:paul_lily_not_accepted)
    get :rejected
    assert_response :success
    refute assigns(:invitations).include?(invitation)

    invitation.accept!
    get :accepted
    assert_response :success
    assert assigns(:invitations).include?(invitation)
  end

  def test_create
    assert_difference -> { @current_user.own_invitations.count }, +1 do

      post :create, user_id: users(:martin), invitation: { message: 'Enough?',
                                                           amount:  100 }

      assert_response :success
      json = JSON.parse(response.body)
      assert json['success']
    end
  end

  def test_create_on_error
    assert_difference -> { @current_user.own_invitations.count }, 0 do

      post :create, user_id: users(:paul), invitation: { message: 'Enough?',
                                                         amount:  100 }

      assert_response :success
      json = JSON.parse(response.body)
      refute json['success']
    end
  end

  def test_destroy
    invitation = @current_user.own_invitations.create invited_user: users(:martin),
                                                      message: 'Its all my money',
                                                      amount: 5
    assert_difference -> { @current_user.own_invitations.count }, -1 do

      delete :destroy, id: invitation

      assert_response :success
    end
  end

  def test_reject
    invitation = invitations(:paul_lily_not_accepted)

    post :reject, id: invitation, reason: 'test_reason'

    assert_response :success
    invitation.reload
    assert invitation.rejected?
    assert_equal invitation.reject_reason, 'test_reason'
  end

  def test_counter
    invitation = invitations(:paul_lily_not_accepted)

    post :counter, id: invitation, invitation: { amount: 100 }

    assert_response :success
    invitation.reload
    assert invitation.pending?
    assert invitation.counter?
  end

  def test_can_accept_invitations
    invitation = invitations(:paul_lily_not_accepted)
    assert_difference [-> { invitation.recipient.messages_sent.count },
                       -> { invitation.inviter.messages_received.count }], +1 do
      post :accept, id: invitation, message: 'Sample message'
      assert invitation.reload.accepted?
      assert_redirected_to accepted_invitations_path
    end
  end

  def test_can_accept_invitations_without_message
    invitation = invitations(:paul_lily_not_accepted)
    assert_difference [-> { invitation.recipient.messages_sent.count },
                       -> { invitation.inviter.messages_received.count }], 0 do
      post :accept, id: invitation
      assert invitation.reload.accepted?
      assert_redirected_to accepted_invitations_path
    end
  end

  def test_can_accept_countered_invitations
    invitation = invitations(:lily_john_countered)
    assert_difference [-> { invitation.recipient.messages_sent.count },
                       -> { invitation.inviter.messages_received.count }], +1 do
      post :accept, id: invitation, message: 'Sample message'
      assert invitation.reload.accepted?
      assert_redirected_to accepted_invitations_path
    end
  end

end
