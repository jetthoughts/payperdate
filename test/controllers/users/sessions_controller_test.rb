require 'test_helper'

class Users::SessionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :users, :profiles

  def setup
    super
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  def test_success_login
    post :create, user: { email: 'martin', password: 'password' }
    assert_redirected_to root_path
  end

  def test_failed_login
    post :create, user: { email: 'martin', password: 'welcome' }
    assert_response :success
    assert_template :new
  end

  def test_save_activity_on_login
    @request.env['REMOTE_ADDR'] = '127.0.0.1'

    assert_difference -> { Activity.count }, +1 do
      post :create, user: { email: 'martin', password: 'password' }
    end

    sign_in_activity = users(:martin).activities.last
    assert_equal users(:martin), sign_in_activity.subject
    assert_equal 'sign_in', sign_in_activity.action

    details = sign_in_activity.details.with_indifferent_access
    assert details[:time], 'does not track time'
    assert details[:ip], 'does not track ip address'
  end

  def test_save_activity_on_logout
    sign_in users(:martin)

    assert_difference -> { Activity.count }, +1 do
      delete :destroy
    end

    sign_out_activity = users(:martin).activities.last
    assert_equal users(:martin), sign_out_activity.subject
    assert_equal 'sign_out', sign_out_activity.action

    assert sign_out_activity.details['time']
  end
end