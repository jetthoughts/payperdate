def sign_in(user)
  visit '/users/login'
  reset_session!

  visit '/users/login'
  within '#new_user' do
    page.fill_in :user_email, with: user.email
    page.fill_in :user_password, with: 'password'
    page.click_button 'Sign in'
  end
end

def confirm_js_popup
  if page.driver.class.name == "Capybara::Selenium::Driver"
    page.driver.browser.switch_to.alert.accept
  elsif page.driver.class.name == "Capybara::Webkit::Driver"
    sleep 1 # prevent test from failing by waiting for popup
    page.driver.browser.accept_js_confirms
  elsif page.driver.class.name == "Capybara::Poltergeist::Driver"
    true
  else
    raise "Unsupported driver"
  end
end
