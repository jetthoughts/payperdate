require 'test_helper'

class Users::RegistrationsControllerTest < ActionController::TestCase
  fixtures :users

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'should be able to sign up successfully' do
    post :create, user: { name: 'New User', email: 'new.user@example.com',
                          nickname: 'new', password: 'password',
                          password_confirmation: 'password' }
    assert_redirected_to root_path
    assert_equal I18n.t('users.notices.signed_up_confirmation_sent'), flash[:notice]
  end

  # delete account

  test 'should have button delete account when editing account' do
    sign_in users(:martin)
    get :edit
    assert_select 'a', 'Delete account'
  end

  test 'should be able to delete account' do
    sign_in users(:martin)
    delete :destroy
    assert_redirected_to root_path
    users(:martin).reload
    assert_equal 'deleted_by_himself', users(:martin).deleted_state
  end

  test 'should not be able to sign up having been deleted' do
    users(:martin).delete!
    post :create, user: { name: 'Martin Hunter', email: 'martin@example.com',
                          nickname: 'martin', password: 'password',
                          password_confirmation: 'password' }
    assert_redirected_to root_path
    assert_equal 'User with this email was deleted. Please contact support to restore your account',
                 flash[:alert]
  end

  test 'delete should track activity' do
    sign_in users(:martin)
    assert_difference -> { Activity.count }, +2 do
      delete :destroy
    end

    activities = users(:martin).activities.last(2)

    delete_user_activity = activities[1]
    assert_equal users(:martin), delete_user_activity.subject
    assert_equal 'delete', delete_user_activity.action
    assert_equal "#{users(:martin).id}", delete_user_activity.details['issuer_id']

    sign_out_activity = activities[0]
    assert_equal users(:martin), sign_out_activity.subject
    assert_equal 'sign_out', sign_out_activity.action
  end

end
