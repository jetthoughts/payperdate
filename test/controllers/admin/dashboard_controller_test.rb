require 'test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  fixtures :admin_users

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

  test 'non master admin should have access to dashboard even when allowed to approve photos' do
    sign_in admin_users(:james)

    get :index
    assert_response :success
  end
end

