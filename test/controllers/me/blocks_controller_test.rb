require 'test_helper'

class Me::BlocksControllerTest < ActionController::TestCase
  fixtures :users, :profiles, :block_relationships

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
  end

end
