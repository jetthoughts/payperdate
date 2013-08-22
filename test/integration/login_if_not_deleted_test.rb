require 'test_helper'

class LoginIfNotDeletedTest < ActionDispatch::IntegrationTest
  fixtures :users, :profiles, :profile_preferences

  setup do
    sign_in users(:martin)
  end

  test 'login should be ok' do
    refute page.has_content? 'Invalid email or password.'
  end
end
