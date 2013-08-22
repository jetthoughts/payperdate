require 'test_helper'


#TODO: Move authorization tests from all controllers to one test unit
#TODO: Extract to separate file
class UsersControllerAuthorizationTest < ActionController::TestCase
  fixtures :users, :block_relationships, :favorites

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
  fixtures :users, :profiles, :profile_preferences

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

  test 'should be able to block another user' do
    post :block, id: users(:ria)
    assert_redirected_to user_profile_path users(:ria)
    assert users(:ria).blocked_for? users(:martin)
    assert_predicate flash[:notice], :present?
  end

  test 'should be able to unblock another user' do
    sign_in users(:robert)
    post :unblock, id: users(:ria)
    assert_redirected_to user_profile_path users(:ria)
    refute users(:ria).blocked_for? users(:robert)
    assert_predicate flash[:notice], :present?
  end

  test 'should not be able to follow blocker' do
    skip 'Should be tested when following will be implemented'
  end

  test 'should not be able to bookmark blocker' do
    skip 'Should be tested when bookmarking will be implemented'
  end

  test 'should not be able to follow blocked by self' do
    skip 'Should be tested when following will be implemented'
  end

  test 'should not be able to bookmark blocked by self' do
    skip 'Should be tested when bookmarking will be implemented'
  end

  test 'block should track activity' do
    assert_difference -> { Activity.count }, +1 do
      post :block, id: users(:mia)
    end

    block_user_activity = users(:martin).activities.last
    assert_equal users(:mia), block_user_activity.subject
    assert_equal 'block', block_user_activity.action
  end

  test 'unblock should track activity' do
    sign_in users(:robert)
    assert_difference -> { Activity.count }, +1 do
      post :unblock, id: users(:ria)
    end

    block_user_activity = users(:robert).activities.last
    assert_equal users(:ria), block_user_activity.subject
    assert_equal 'unblock', block_user_activity.action
  end

  test 'members of block relationship should not be able to leave comments to each other' do
    skip 'Should be tested when comments will be implemented'
  end

  test 'blocker should be able to see comments on blocked page' do
    skip 'Should be tested when comments will be implemented'
  end

  test 'blocked should not be able to see comments on blocker`s page' do
    skip 'Should be tested when comments will be implemented'
  end

  test 'should have link to blocked user list' do
    get :index
    assert_select 'a', 'Blocked users'
  end

  test 'unsubscribe action' do
    get :unsubscribe, md_email: users(:martin).email
    assert_redirected_to root_path
    refute users(:martin).reload.subscribed
  end

  test 'favorite action' do
    post :favorite, id: users(:ria)
    assert_redirected_to user_profile_path users(:ria)
    assert users(:ria).favorite_for? users(:martin)
  end

  test 'remove favorite action' do
    sign_in users(:robert)

    assert users(:mia).favorite_for? users(:robert)
    post :remove_favorite, id: users(:mia)
    assert_redirected_to user_profile_path users(:mia)
    refute users(:mia).favorite_for? users(:robert)
  end

end
