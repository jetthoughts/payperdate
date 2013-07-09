require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test 'should be able to view all users if profile filled' do
    sign_in users(:martin)

    get :index
    assert_response :success
  end

  test 'should be able to view all users' do
    sign_in users(:paul)

    get :index
    assert_redirected_to edit_profile_path
  end
end
