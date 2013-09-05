require 'test_helper'

class Me::SettingsControllerTest < ActionController::TestCase
  fixtures :users, :user_settings

  setup do
    @current_user = users(:martin)
    sign_in @current_user
  end

  test 'user should have settings' do
    assert_not_nil @current_user.settings
  end

  test 'edit should respond success' do
    get :edit
    assert_response :success
    assert_not_nil assigns(:settings)
  end

end
