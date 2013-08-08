require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  fixtures :users, :messages, :block_relationships

  def setup
    @user = users(:mia)
    sign_in @user
    @ria = users(:ria)
    @robert = users(:robert)
  end

  def test_unauthenticated_redirect_to_login_page
    sign_out @user
    get :new
    assert_redirected_to new_user_session_path
  end


  def test_get_new
    recipient = users(:john)
    get :new, user_id: recipient.id
    assert_response :success
  end

  def test_new_message
    recipient = users(:john)
    get :new, user_id: recipient.id
    message = assigns(:message)
    assert_equal recipient, message.recipient
  end

  def test_redirect_after_success_create
    recipient = users(:john)
    put :create, user_id: recipient.id, message: { content: 'Hello' }
    assert_redirected_to user_profile_path(recipient)
    assert_not_nil flash[:notice]
  end

  def test_render_new_after_validation_error
    recipient = users(:john)
    put :create, user_id: recipient.id, message: { conent: '' }
    assert_response :success
    message = assigns(:message)
    assert_includes message.errors, :content
  end

  def test_render_new_when_sending_to_blocker
    sign_in @ria
    put :create, user_id: @robert, message: { content: 'Huhu!' }
    assert_response :success
    assert_includes assigns(:message).errors, :recipient_id
  end

  def test_redirect_when_sending_to_blocked
    sign_in @robert
    put :create, user_id: @ria, message: { content: 'Hello?' }
    assert_redirected_to user_profile_path(@ria)
  end

end
