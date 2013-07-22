require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  def setup
    @controller = ::Admin::UsersController.new
  end

  fixtures :admin_users

  test 'master admin should have access to users' do
    sign_in admin_users(:admin)

    get :index
    assert_response :success
  end

  test 'non master admin should not have access to users' do
    sign_in admin_users(:john)

    get :index
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'non master admin should not have access to users even when allowed to approve photos' do
    sign_in admin_users(:james)

    get :index
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end
end
