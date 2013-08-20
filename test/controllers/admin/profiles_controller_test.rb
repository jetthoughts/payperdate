require 'test_helper'

class Admin::ProfilesControllerTest < ActionController::TestCase
  def setup
    @controller = ::Admin::ProfilesController.new
  end

  fixtures :admin_users, :users, :profiles, :profile_multiselects

  test 'admin should be able to view users profile' do
    sign_in admin_users(:admin)

    get :show, id: profiles(:martins)
    assert_response :success
  end
end
