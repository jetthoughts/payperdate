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

    users_dates = assigns(:users_dates)
    users_dates.each do |users_date|
      assert users_date.belongs_to?(@user)
    end
  end

  def test_unlocked_return_all_unlocked_dates
    get :unlocked
    assert_response :success

    users_dates = assigns(:users_dates)
    users_dates.each do |users_date|
      assert users_date.belongs_to?(@user) && users_date.unlocked?
    end
  end

  def test_locked_return_all_locked_dates
    get :locked
    assert_response :success

    users_dates = assigns(:users_dates)
    users_dates.each do |users_date|
      assert users_date.belongs_to?(@user) && !users_date.unlocked?
    end
  end

  def test_unlock_should_not_be_unlocked_by_date_recipient
    users_date = users_dates(:locked_date_john_lily)
    assert_raise CanCan::AccessDenied do
      post :unlock, id: users_date
    end
    refute users_date.reload.unlocked?
  end

  def test_unlock_should_not_be_unlocked_by_date_owner_if_credits_low
    john = users(:john)
    john.update credits_amount: 0
    sign_in john

    users_date = users_dates(:locked_date_john_lily)
    post :unlock, id: users_date
    assert_redirected_to users_dates_path
    assert_not_nil flash[:alert]
    refute users_date.reload.unlocked?
  end

  def test_unlock_should_be_unlocked_by_date_owner
    john = users(:john)
    john.update credits_amount: 100
    sign_in john

    users_date = users_dates(:locked_date_john_lily)
    post :unlock, id: users_date
    assert_redirected_to users_dates_path
    assert_nil flash[:alert]
    assert users_date.reload.unlocked?
  end

end
