require 'test_helper'

class Me::ProfilesControllerTest < ActionController::TestCase
  fixtures :users, :profiles, :profile_multiselects

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

  test 'update tracks activity' do
    sign_in users(:martin)

    assert_difference -> { Activity.count }, +1 do
      patch :update, profile: { personal_preferences_sex: 'M' }
    end

    change_profile_activity = users(:martin).activities.last
    assert_equal profiles(:martins), change_profile_activity.subject
    assert_equal 'update', change_profile_activity.action
  end

  test 'unsuccessfull update' do
    sign_in users(:martin)
    patch :update, profile: { general_info_address_line_1: '' }
    assert_response :success
    refute assigns(:profile).valid?
    assert_equal 'Entered profile data is invalid', flash[:alert]
  end

  test 'successfull update should be with flash notice' do
    sign_in users(:martin)
    patch :update, profile: { personal_preferences_sex: 'F' }
    assert_redirected_to me_path
    assert_equal 'Profile successfully updated', flash[:notice]
  end
end
