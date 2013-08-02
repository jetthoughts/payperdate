require 'test_helper'

class Admin::GiftTemplatesControllerTest < ActionController::TestCase
  fixtures :admin_users

  def setup
    @controller = ::Admin::GiftTemplatesController.new
  end

  test 'master admin should have access to gifts' do
    sign_in admin_users(:admin)

    get :index
    assert_response :success
  end

  test 'non master admin should not have access to gifts' do
    sign_in admin_users(:john)

    get :index
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'non master admin should have access to gifts if allowed to manage gifts and winks' do
    sign_in admin_users(:anthony)

    get :index
    assert_response :success
  end
end