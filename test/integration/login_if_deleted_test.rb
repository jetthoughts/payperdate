require 'test_helper'

class LoginIfDeletedTest < ActionDispatch::IntegrationTest

  fixtures :users, :profiles, :profile_multiselects

  def setup
    users(:martin).delete_account!
    sign_in users(:martin)
  end

  test 'login should result in error' do
    assert page.has_content? 'Invalid email or password.'
  end
end
