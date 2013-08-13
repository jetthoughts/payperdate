require 'test_helper'

class AcceptInviteTest < ActionDispatch::IntegrationTest

  fixtures :users, :profiles, :invitations, :users_communications, :communication_costs

  # def setup
  #   reset_session!
  # end

  test 'should have right links' do
    martin = users(:martin)
    mia = users(:mia)

    sign_in mia
    visit "/me/invitations"

    within('.invitation') do
      assert page.has_link?('Accept')
      assert page.has_link?('Reject')
      refute page.has_link?('Unlock')
      refute page.has_link?('Messages')
    end

    page.click_link 'Accept'
    page.fill_in :message, with: "Test message"
    within(".accept_form") do
      page.click_button 'Accept'
    end
    page.click_link 'mia'
    page.click_link 'SignOut'

    sign_in martin
    visit "/me/invitations"

    page.click_link 'Accepted'
    within('.invitation') do
      assert page.has_link?('Unlock')
      refute page.has_link?('Accept')
      refute page.has_link?('Reject')
      refute page.has_link?('Messages')
    end

    within('.invitation') do
      page.click_link 'Unlock'
      confirm_js_popup
      assert page.has_link?('Messages')
    end

  end
end
