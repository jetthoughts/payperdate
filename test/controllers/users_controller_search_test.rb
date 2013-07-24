require 'test_helper'

class UsersControllerSearchTest < ActionController::TestCase
  tests UsersController
  fixtures :users, :profiles

  def setup
    initial_setup
    @user = users(:robert)
    sign_in @user
  end

  test 'user should not see himself in search results' do
    get :index
    assert_response :success
    assert_not_nil all_users
    refute all_users.any? { |e| e.id == @user.id }
    assert_equal 4, all_users.count
  end

  # tests geo filters
  test 'user should be able to filter too far away users' do
    DISTANCE = 50

    get :search, location: 'Miami', max_distance: ''
    assert_response :success
    all_users_count = all_users.count

    get :search, location: 'Miami', max_distance: DISTANCE
    assert_response :success
    filtered_users_count = all_users.count

    assert all_users_count > filtered_users_count, 'some users should have been filtered'
    assert all_users_are &in_range(DISTANCE)
  end

  # tests checkbox filters
  test 'user should be able to filter by sex' do
    get :search, q: { personal_preferences_sex_in: %w(F) }
    assert_response :success
    assert all_users_are &female

    get :search, q: { personal_preferences_sex_in: %w(M) }
    assert_response :success
    assert all_users_are &male

    get :search, q: { personal_preferences_sex_in: %w(M F) }
    assert_response :success
    assert any_users_are &female
    assert any_users_are &male
  end

  # tests range filters
  test 'user should be able to filter by age' do
    get :search, q: { optional_info_age_gteq: 20, optional_info_age_lteq: 30 }
    assert_response :success
    assert all_users_are &aged_for((20..30).to_a)
    assert_equal 2, all_users.count
  end

  # test string filters
  test 'user should be able to filter by city' do
    get :search, q: { general_info_city_cont: 'iam' }
    assert_equal 3, all_users.count

    get :search, q: { general_info_city_cont: 'rivoy' }
    assert_equal 1, all_users.count
  end

  private

  def all_users
    assigns(:users)
  end

  def all_users_are(&block)
    all_users.all? &block
  end

  def any_users_are(&block)
    all_users.any? &block
  end

  def female
    -> e { e.profile.personal_preferences_sex == 'F' }
  end

  def male
    -> e { e.profile.personal_preferences_sex == 'M' }
  end

  def in_range(distance)
    -> e { e.distance <= distance }
  end

  def aged_for(range)
    -> e { range.include? e.profile.optional_info_age }
  end
end
