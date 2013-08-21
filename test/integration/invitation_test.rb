require 'test_helper'

class AcceptInviteTest < ActionDispatch::IntegrationTest

  fixtures :users, :profiles, :invitations, :users_dates, :communication_costs

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
      refute page.has_link?('Messages')
    end

    visit "/me/users_dates"
    within('.users_dates') do
      refute page.has_link?('Unlock')
    end

    visit "/me/invitations"
    page.click_link 'Accept'
    page.fill_in :message, with: "Test message"
    within(".accept_form") do
      page.click_button 'Accept'
    end

    visit "/me/users_dates"
    within('.users_dates') do
      refute page.has_link?('Unlock')
      assert page.has_link?(martin.name)
    end

    page.click_link 'mia'
    page.click_link 'SignOut'

    sign_in martin
    visit "/me/invitations"

    page.click_link 'Accepted'
    within('.invitation') do
      refute page.has_link?('Accept')
      refute page.has_link?('Reject')
      refute page.has_link?('Messages')
    end

    visit "/me/users_dates"
    within('.users_dates') do
      assert page.has_link?('Unlock')
      page.click_link 'Unlock'
      confirm_js_popup
      refute page.has_link?('Unlock')
    end

  end
end
