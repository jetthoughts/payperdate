require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  fixtures :users, :messages

  def setup
    @user = users(:mia)
    sign_in @user
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

end