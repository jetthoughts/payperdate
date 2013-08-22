require 'test_helper'

class LoginIfNotBlockedTest < ActionDispatch::IntegrationTest

  fixtures :users, :profiles, :profile_preferences

  def setup
    sign_in users(:lily)
  end

  test 'login should be ok' do
    refute page.has_content? 'Invalid email or password.'
  end

end
