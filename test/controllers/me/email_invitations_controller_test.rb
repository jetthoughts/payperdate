require 'test_helper'

class Me::EmailInvitationsControllerTest < ActionController::TestCase
  fixtures :users

  setup do
    @current_user = users(:martin)
    sign_in @current_user
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:email_invitation)
  end

  test 'create should render new on error' do
    get :create, email_invitation: { email: users(:mia).email }
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:email_invitation)
  end

  test 'create should redirect to dashboard on success' do
    get :create, email_invitation: { email: 'test@example.com' }
    assert_redirected_to root_path
    assert_match /sent/, flash[:notice]
  end

end
