require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test 'should be able to view all users if profile filled' do
    sign_in users(:martin)

    get :index
    assert_response :success
  end

  test 'should not be able to view all users when profile is not filled' do
    sign_in users(:paul)

    get :index
    assert_redirected_to edit_profile_path
  end

  test 'should be able to see search form' do
    sign_in users(:martin)

    get :index
    assert_response :success
    assert_select 'input[value="Search"]', true
  end

  test 'should be able to search' do
    sign_in users(:martin)

    get :search, search: {}
    assert_response :success
  end
end
