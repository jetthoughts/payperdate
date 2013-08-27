require 'test_helper'

class Me::UsersDatesControllerTest < ActionController::TestCase

  fixtures :users, :users_dates

  def setup
    @user = users(:lily)
    sign_in @user
  end

  def test_index_return_all_dates
    get :index
    assert_response :success

    dates = assigns(:users_dates)
    dates.each do |users_date|
      assert users_date.belongs_to?(@user)
    end
  end

  def test_unlocked_return_all_unlocked_dates
    get :unlocked
    assert_response :success

    dates = assigns(:users_dates)
    dates.each do |users_date|
      assert users_date.belongs_to?(@user) && users_date.unlocked?
    end
  end

  def test_locked_return_all_locked_dates
    get :locked
    assert_response :success

    dates = assigns(:users_dates)
    dates.each do |users_date|
      assert users_date.belongs_to?(@user) && !users_date.unlocked?
    end
  end

end
