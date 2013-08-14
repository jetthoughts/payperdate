require 'test_helper'
require 'capybara/rails'

class LoginIfNotBlockedTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  fixtures :users, :profiles, :profile_multiselects

  def setup
    reset_session!
    visit '/users/login'
    within '#new_user' do
      page.fill_in :user_email, with: users(:lily).email
      page.fill_in :user_password, with: 'password'
      page.click_button 'Sign in'
    end
  end

  test 'login should be ok' do
    refute page.has_content? 'Invalid email or password.'
  end
end

class LoginIfBlockedTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  fixtures :users, :profiles, :profile_multiselects

  def setup
    reset_session!
    users(:lily).block!
    visit '/users/login'
    within '#new_user' do
      page.fill_in :user_email, with: users(:lily).email
      page.fill_in :user_password, with: 'password'
      page.click_button 'Sign in'
    end
  end

  test 'login should result in alert about being blocked' do
    assert page.has_content?(I18n.t 'devise.failure.blocked'), 'No alert about being blocked'
  end
end
