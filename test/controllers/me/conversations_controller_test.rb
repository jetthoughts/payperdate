require 'test_helper'

class Me::ConversationsControllerTest < ActionController::TestCase

  fixtures :users, :messages, :users_dates

  def setup
    @user = users(:john)
    sign_in @user
    @mia = users(:mia)
  end

  def test_index_returns_success
    get :index
    assert_response :success
  end

  def test_index_returns_conversations
    get :index
    assigns(:conversations).each do |conversation|
      assert_equal @user, conversation.viewer
    end
  end

  def test_show_returns_success
    get :show, id: @mia
    assert_response :success
  end

  def test_show_returns_conversation
    get :show, id: @mia
    conversation = assigns(:conversation)
    assert @mia, conversation.interlocutor
    assert @user, conversation.viewer
  end

  def test_show_set_read_to_all_messages
    get :show, id: @mia
    conversation = assigns(:conversation)
    refute conversation.has_unread?
  end

  def test_show_redirect_to_conversation_on_error
    get :show, id: @user
    assert_redirected_to conversations_path
  end

  def test_append_redirect_to_conversation_on_error
    assert_difference -> { Conversation.by_users(@user, @mia).messages.count }, 0 do
      post :append, id: @mia, message: { content: '' }
      assert_redirected_to conversation_path(@mia)
    end
  end

  def test_append_redirect_to_conversation_on_success
    assert_difference -> { Conversation.by_users(@user, @mia).messages.count }, +1 do
      post :append, id: @mia, message: { content: 'Hello' }
      assert_redirected_to conversation_path(@mia)
    end
  end

end
