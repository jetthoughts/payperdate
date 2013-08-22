require 'test_helper'

class Me::ViewersControllerTest < ActionController::TestCase

  fixtures :users, :profiles, :profile_preferences, :profile_views

  setup do
    @current_user = users(:martin)
    sign_in @current_user
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get list of viewers on index' do
    get :index
    viewers = @current_user.viewers
    assert viewers.count > 0
    viewers.each do |user|
      assert_select 'a', user.name
    end
  end

end
