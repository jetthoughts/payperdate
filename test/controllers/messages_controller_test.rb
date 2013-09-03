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
    assert_match /can't send/, flash[:alert]
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
    assert_match /sent/, flash[:notice]
  end

  def test_render_new_after_validation_error
    put :create, user_id: @john.id, message: { conent: '' }
    assert_response :success
    message = assigns(:message)
    assert_includes message.errors, :content
  end

  def test_xhr_create_should_return_rendered_partial
    xhr :put, :create, user_id: @john, message: { content: 'some message' }
    assert_response :success
    assert_template 'me/conversations/_message'
  end

  def test_xhr_create_should_return_nil_on_error
    xhr :put, :create, user_id: @john, message: { content: '' }
    assert_response :success
    assert_equal ' ', response.body
  end

  def test_redirect_with_alert_when_sending_to_blocker
    sign_in @ria
    put :create, user_id: @robert, message: { content: 'Huhu!' }
    assert_redirected_to user_profile_path(@robert)
    assert_not_nil flash[:alert]
    assert_match /can't send/, flash[:alert]
  end

  def test_redirect_with_notice_when_sending_to_blocked
    sign_in @robert
    put :create, user_id: @ria, message: { content: 'Hello?' }
    assert_redirected_to user_profile_path(@ria)
    assert_not_nil flash[:notice]
    assert_match /sent/, flash[:notice]
  end

end
