require 'test_helper'

class LoginIfDeletedTest < ActionDispatch::IntegrationTest

  fixtures :users, :profiles, :profile_multiselects

  def setup
    users(:martin).delete_by_admin!
    sign_in users(:martin)
  end

  test 'login should result in error' do
    assert page.has_content? 'This account was deleted'
  end
end
