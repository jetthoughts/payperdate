require 'test_helper'

class MemberReportsControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    sign_in users(:mia)
  end

  test 'should get new' do
    get :new, user_id: users(:martin)
    assert_response :success
  end

  test 'should redirect after create' do
    post :create, user_id: users(:martin), member_report: { content_type: 'Profile', content_id: users(:martin).profile, message: '!' }
    assert_redirected_to user_profile_path(users(:martin))
  end

  test 'should not redirect with errors' do
    post :create, user_id: users(:martin), member_report: { content_type: 'Profile', content_id: users(:martin).profile, message: '' }
    assert_response :success
  end

end
