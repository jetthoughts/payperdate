require 'test_helper'
require 'capybara/rails'

class LoginIfNotBlockedTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  fixtures :users, :profiles

  def setup
    reset_session!
    visit '/users/login'
    page.fill_in :user_email, with: users(:lily).email
    page.fill_in :user_password, with: 'password'
    page.click_button 'Sign in'
  end

  test 'login should be ok' do
    refute page.has_content? 'Invalid email or password.'
  end
end

class LoginIfBlockedTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  fixtures :users, :profiles

  def setup
    reset_session!
    users(:lily).block!
    visit '/users/login'
    page.fill_in :user_email, with: users(:lily).email
    page.fill_in :user_password, with: 'password'
    page.click_button 'Sign in'
  end

  test 'login should result in alert about being blocked' do
    assert page.has_content?('Your account was suspended.'), 'No alert about being blocked'
  end
end
