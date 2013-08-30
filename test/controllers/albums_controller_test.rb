require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  fixtures :users, :profiles, :albums

  def setup
    sign_in users(:martin)
  end

  test 'should not be able to see albums if has no filled profile' do
    sign_in users(:paul)

    get :index
    assert_redirected_to edit_profile_path
  end

  test 'should be able to see albums if has filled profile' do
    get :index
    assert_response :success
    assert_equal assigns(:albums).count, 2
  end

  test 'should be able to create album' do
    assert_difference -> { users(:martin).albums.count }, +1 do
      post :create, album: { name: 'Test Album' }
      assert_redirected_to users(:martin).albums.last
    end
  end

  # FIXME: This test was skipped because it triggers non-existant view error
  #        This error should be fixed before using this test
  test 'should not be able to create album with blank name' do
    skip 'Triggers non-existant view error. Requires further investigation'
    assert_difference -> { users(:martin).albums.count }, 0 do
      post :create, album: { name: '' }
      assert_response :success
      refute assigns(:album).valid?
    end
  end

  test 'album edit form' do
    get :edit, id: albums(:favorites)
    assert_response :success
    assert_equal assigns(:album).name, albums(:favorites).name
    assert_select 'input[type="text"]', count: 1
    assert_select 'input[type="submit"]'
  end

  test 'should be able to update album' do
    patch :update, id: albums(:favorites), album: { name: 'The best' }
    assert_redirected_to albums_path
    assert_equal 'The best', albums(:favorites).reload.name
  end

  test 'should not be able to update album using blank name' do
    patch :update, id: albums(:favorites), album: { name: '' }
    assert_response :success
    refute assigns(:album).valid?
  end

  test 'album destroy' do
    assert_difference -> { users(:martin).albums.count }, -1 do
      delete :destroy, id: albums(:favorites)
      assert_response :success
    end
  end
end
