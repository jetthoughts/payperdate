require 'test_helper'


#TODO: Move authorization tests from all controllers to one test unit
#TODO: Extract to separate file
class UsersControllerAuthorizationTest < ActionController::TestCase
  fixtures :users

  tests UsersController

  test 'should be redirected to sign in page' do
    get :index
    assert_redirected_to new_user_session_path
  end

  test 'should not be able to access users page' do
    sign_in users(:paul)

    get :index
    assert_redirected_to edit_profile_path
  end
end

class UsersControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    sign_in users(:martin)
  end

  test 'should be able to view all users if profile filled' do
    get :index
    assert_response :success
  end

  test 'should not be able to view all users when profile is not filled' do
    sign_in users(:paul)

    get :index
    assert_redirected_to edit_profile_path
  end

  test 'should be able to see search form' do
    get :index
    assert_response :success
    assert_select 'input[value="Search"]', true
  end

  test 'should be able to search' do
    get :search, q: {}
    assert_response :success
  end
end
