require 'test_helper'

class LoginIfBlockedTest < ActionDispatch::IntegrationTest

  fixtures :users, :profiles, :profile_multiselects

  def setup
    users(:lily).block!

    sign_in users(:lily)
  end

  test 'login should result in alert about being blocked' do
    assert page.has_content?(I18n.t 'devise.failure.blocked'), 'No alert about being blocked'
  end
end
