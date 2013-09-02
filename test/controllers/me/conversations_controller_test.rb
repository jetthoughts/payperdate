require 'test_helper'

class Me::ConversationsControllerTest < ActionController::TestCase

  fixtures :users, :messages, :users_dates

  setup do
    @user = users(:john)
    sign_in @user
    @mia = users(:mia)
  end

  test 'index returns success' do
    get :index
    assert_response :success
  end

  test 'index returns conversations' do
    get :index
    assigns(:conversations).each do |conversation|
      assert_equal @user, conversation.viewer
    end
  end

  test 'show returns success' do
    get :show, id: @mia
    assert_response :success
  end

  test 'show returns conversation' do
    get :show, id: @mia
    conversation = assigns(:conversation)
    assert @mia, conversation.interlocutor
    assert @user, conversation.viewer
  end

  test 'show sets read to all messages' do
    get :show, id: @mia
    conversation = assigns(:conversation)
    refute conversation.has_unread?
  end

  test 'show redirect to conversation on error' do
    get :show, id: @user
    assert_redirected_to conversations_path
  end

end
