require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  def setup
    sign_in users(:paul)
  end

  test 'should get edit' do
    get :edit
    assert_response :success
  end
end
