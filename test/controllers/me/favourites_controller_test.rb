require 'test_helper'

class Me::FavoritesControllerTest < ActionController::TestCase

  fixtures :users, :favorites

  test 'should get index' do
    sign_in users(:robert)
    get :index
    assert_response :success
  end

  test 'should get list of favourites on index' do
    robert = users(:robert)
    sign_in robert
    get :index
    favorites = robert.favorite_users
    assert favorites.count > 0
    favorites.each do |user|
      assert_select 'a', user.name
    end
  end

  test 'should get back' do
    sign_in users(:mia)
    get :back
    assert_response :success
  end

  test 'should get list of who favourites me on back' do
    mia = users(:mia)
    sign_in mia
    get :back
    favorites_me = mia.back_favorite_users
    assert favorites_me.count > 0
    favorites_me.each do |user|
      assert_select 'a', user.name
    end
  end

end
