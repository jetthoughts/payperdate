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

  def test_get_message_show_normal
    get :show, id: messages(:john_message_sent)
    assert_response :success
  end

  def test_message_state_changes_to_read_on_show
    message = messages(:john_message_received_unread)
    get :show, id: message
    message.reload
    assert message.read?
  end

  def test_get_message_show_deleted
    assert_raise ActionController::RoutingError do
      get :show, id: messages(:john_message_sent_deleted)
    end
  end

  def test_delete_destroy_redirect_on_success
    delete :destroy, id: messages(:john_message_received_unread)
    assert_redirected_to messages_path
    assert_not_nil flash[:notice]
  end

  def test_delete_destroy_not_found_on_error
    delete :destroy, id: messages(:john_message_received_deleted)
    assert_redirected_to messages_path
    assert_not_nil flash[:alert]
  end

end