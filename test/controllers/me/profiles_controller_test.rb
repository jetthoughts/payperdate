require 'test_helper'

class Me::ProfilesControllerTest < ActionController::TestCase
  def setup
    sign_in users(:paul)
  end

  test 'should not be able to edit his profile' do
    get :edit
    assert_response :success
  end

  test 'should not be able to see own profile without filled profile' do
    get :show
    assert_redirected_to edit_profile_path
  end

  test 'should be able to see own profile ' do
    sign_in users(:martin)
    get :show
    assert_response :success
  end
end
