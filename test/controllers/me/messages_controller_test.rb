require 'test_helper'

class Me::MessagesControllerTest < ActionController::TestCase

  fixtures :users, :messages

  def setup
    @user = users(:john)
    sign_in @user
  end

  def test_unauthenticated_redirect_to_login_page
    sign_out @user
    get :index
    assert_redirected_to new_user_session_path
  end

  def test_get_index
    get :index
    assert_response :success
  end

  def test_get_all_user_messages
    get :index
    messages = assigns(:messages)
    messages.each do |message|
      assert message.sender_id == @user.id || message.recipient_id == @user.id
    end
  end

  def test_get_unread
    get :unread
    assert_response :success
  end

  def test_get_received_by_user_unread_messages
    get :unread
    messages = assigns(:messages)
    messages.each do |message|
      assert message.recipient_id == @user.id && message.unread?
    end
  end

  def test_get_received
    get :received
    assert_response :success
  end

  def test_get_received_by_user_messages
    get :received
    messages = assigns(:messages)
    messages.each do |message|
      assert message.recipient_id == @user.id
    end
  end

  def test_get_sent
    get :sent
    assert_response :success
  end

  def test_get_sent_by_user_messages
    get :sent
    messages = assigns(:messages)
    messages.each do |message|
      assert message.sender_id == @user.id
    end
  end

end
