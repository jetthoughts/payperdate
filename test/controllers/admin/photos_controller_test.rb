require 'test_helper'

class Admin::PhotosControllerTest < ActionController::TestCase
  fixtures :admin_users

  def setup
    @controller = ::Admin::PhotosController.new
  end

  test 'master admin should have access to photos' do
    sign_in admin_users(:admin)

    get :index
    assert_response :success
  end

  test 'non master admin should not have access to photos' do
    sign_in admin_users(:john)

    get :index
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'non master admin should have access to photos if allowed to approve photos' do
    sign_in admin_users(:james)

    get :index
    assert_response :success
  end
end
