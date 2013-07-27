require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    sign_in users(:paul)
  end

  test 'should should not be able see albums' do
    get :index
    assert_redirected_to edit_profile_path
  end
end
