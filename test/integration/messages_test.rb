require 'test_helper'

class MessagesTest < ActionDispatch::IntegrationTest

  fixtures :users, :invitations, :users_dates, :communication_costs

  test 'should have hidden messages' do
    martin = users(:martin)
    mia = users(:mia)

    sign_in mia
    visit "/me/invitations"

    page.click_link 'Accept'
    page.fill_in :message, with: "Test message"
    within(".accept_form") do
      page.click_button 'Accept'
    end
    page.click_link 'mia'
    page.click_link 'SignOut'

    sign_in martin
    visit "/me/messages"
    within("table tr:first-child td:nth-child(3)") do
      assert page.has_content?("HIDDEN")
      refute page.has_content?("Test message")
    end

    visit "/me/users_dates"
    page.click_link 'Locked'
    within('.users_date') do
      page.click_link 'Unlock'
      confirm_js_popup
    end

    visit "/me/messages"
    within("table tr:first-child td:nth-child(3)") do
      refute page.has_content?("DEFAULT")
      assert page.has_content?("Test message")
    end

  end
end

