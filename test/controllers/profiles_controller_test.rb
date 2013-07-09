require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  def setup
    sign_in users(:martin)
  end

  test 'should not be able to see others user before current user fill profile' do
    sign_in users(:paul)
    get :show, user_id: users(:john)
    assert_redirected_to edit_profile_path
  end

  test 'should be able see own profile' do
    sign_in users(:paul)
    get :show, user_id: users(:paul)
    assert_redirected_to edit_profile_path
  end

  test 'should be not able to see others user without filled profile' do
    get :show, user_id: users(:john)
    assert_redirected_to root_path
  end

  test 'should be able to see others user profile' do
    get :show, user_id: users(:martin)
    assert_response :success
  end

  test 'should be able see others user with filled profile' do
    get :show, user_id: users(:john)
    assert_redirected_to root_path
  end
end
