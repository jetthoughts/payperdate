require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  fixtures :users, :messages, :block_relationships, :users_dates

  def setup
    @user = users(:mia)
    sign_in @user
    @ria = users(:ria)
    @robert = users(:robert)
    @john = users(:john)
  end

  def test_unauthenticated_redirect_to_login_page
    sign_out @user
    get :new
    assert_redirected_to new_user_session_path
  end

  def test_get_new
    get :new, user_id: @john.id
    assert_response :success
  end

  def test_get_new_with_no_dated
    get :new, user_id: @ria.id
    assert_redirected_to user_profile_path(@ria)
    assert_not_nil flash[:alert]
  end

  def test_new_message
    get :new, user_id: @john.id
    message = assigns(:message)
    assert_equal @john, message.recipient
  end

  def test_redirect_after_success_create
    put :create, user_id: @john.id, message: { content: 'Hello' }
    assert_redirected_to user_profile_path(@john)
    assert_not_nil flash[:notice]
  end

  def test_render_new_after_validation_error
    put :create, user_id: @john.id, message: { conent: '' }
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
