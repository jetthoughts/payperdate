require 'test_helper'
require 'capybara/rails'

class LoginIfNotDeletedTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  fixtures :users, :profiles

  def setup
    reset_session!
    visit "/users/login"
    page.fill_in :user_email, with: users(:martin).email
    page.fill_in :user_password, with: 'password'
    page.click_button 'Sign in'
  end

  test 'login should be ok' do
    refute page.has_content? 'Invalid email or password.'
  end
end

class LoginIfDeletedTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  fixtures :users, :profiles

  def setup
    reset_session!
    users(:martin).delete_account!
    visit "/users/login"
    page.fill_in :user_email, with: users(:martin).email
    page.fill_in :user_password, with: 'password'
    page.click_button 'Sign in'
  end

  test 'login should result in error' do
    assert page.has_content? 'Invalid email or password.'
  end
end
