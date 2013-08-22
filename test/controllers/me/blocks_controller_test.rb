require 'test_helper'

class Me::BlocksControllerTest < ActionController::TestCase
  fixtures :users, :profiles, :profile_preferences, :block_relationships

  setup do
    sign_in users(:robert)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get list of blocked users on index' do
    get :index
    assert_select 'a', 'Ria Condra'
    assert_select 'span', 'Not deleted' # just hidden span to test
  end

  test 'should get list with deleted labels' do
    users(:ria).delete!
    get :index
    assert_select 'span', 'Deleted'
  end

end
