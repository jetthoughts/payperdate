require 'test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  def setup
    @controller = ::Admin::DashboardController.new
  end

  fixtures :admin_users

  test 'master admin should have access to dashboard' do
    sign_in admin_users(:admin)

    get :index
    assert_response :success
  end

  test 'non master admin should have access to dashboard' do
    sign_in admin_users(:john)

    get :index
    assert_response :success
  end
end

# class AdminUserControllerTest < ActionController::TestCase
#   fixtures :admin_users

#   before { sign_in admin_users(:admin) }

#   test 'should have access to dashboard' do
#     get admin_root_path
#     assert_response :success

#     get admin_dashboard_path
#     assert_response :success
#   end

#   test 'should have access to admin users' do
#     get admin_admin_users_path
#     assert_response :success
#   end

#   test 'should have access to photos' do
#     get admin_photos_path
#     assert_response :success
#   end

#   test 'should have access to users' do
#     get admin_users_path
#     assert_response :success
#   end
# end

# class NonMasterAdminPermissionsTest < ActionController::TestCase
#   fixtures :admin_users

#   before { sign_in admin_users(:john) }

#   test 'should have access to dashboard' do
#     get admin_root_path
#     assert_response :success

#     get admin_dashboard_path
#     assert_response :success
#   end

#   test 'shouldnt have access to admin users' do
#     get admin_admin_users_path
#     assert_redirected_to admin_root_path
#     assert_equal 'You are not authorized to perform this action.', flash[:alert]
#   end

#   test 'shouldnt have access to photos' do
#     get admin_photos_path
#     assert_redirected_to admin_root_path
#     assert_equal 'You are not authorized to perform this action.', flash[:alert]
#   end

#   test 'shouldnt have access to users' do
#     get admin_users_path
#     assert_redirected_to admin_root_path
#     assert_equal 'You are not authorized to perform this action.', flash[:alert]
#   end
# end

