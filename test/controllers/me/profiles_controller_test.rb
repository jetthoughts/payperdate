require 'test_helper'

class Me::ProfilesControllerTest < ActionController::TestCase
  fixtures :users, :profiles

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

  def test_update_tracks_activity
    sign_in users(:martin)

    assert_difference -> { Activity.count }, +1 do
      patch :update, profile: { personal_preferences: { sex: 'M' } }
    end

    change_profile_activity = users(:martin).activities.last
    assert_equal profiles(:martins), change_profile_activity.subject
    assert_equal 'update', change_profile_activity.action
  end
end
