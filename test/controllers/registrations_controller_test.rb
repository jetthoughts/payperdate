require 'test_helper'

class Users::RegistrationsControllerTest < ActionController::TestCase
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'should be able to sign up successfully' do
    post :create, user: { name: 'New User', email: 'new.user@example.com',
                          nickname: 'new', password: 'password',
                          password_confirmation: 'password' }
    assert_redirected_to root_path
    assert_equal I18n.t('users.notices.signed_up_confirmation_sent'), flash[:notice]
  end
end
