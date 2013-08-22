require 'test_helper'

class UsersControllerSearchTest < ActionController::TestCase
  tests UsersController
  fixtures :users, :profiles, :profile_preferences

  def setup
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

    post :search, location: 'Miami', max_distance: ''
    assert_response :success
    all_users_count = all_users.count

    post :search, location: 'Miami', max_distance: DISTANCE
    assert_response :success
    filtered_users_count = all_users.count

    assert all_users_count > filtered_users_count, 'some users should have been filtered'
    assert all_users_are &in_range(DISTANCE)
  end

  # tests checkbox filters
  test 'user should be able to filter by sex' do
    post :search, query: { personal_preferences_sex_in: %w(female) }
    assert_response :success
    assert all_users_are &female
    assert all_users.count > 0

    post :search, query: { personal_preferences_sex_in: %w(male) }
    assert_response :success
    assert all_users_are &male
    assert all_users.count > 0

    post :search, query: { personal_preferences_sex_in: %w(male female) }
    assert_response :success
    assert any_users_are &female
    assert any_users_are &male
    assert all_users.count > 0
  end

  test 'user should be able to filter by partners sex' do
    # post :search, query: { personal_partners_sex_multiselect: %w(female) }
    post :search, query: { g: {
      :"0" => { m: 'or', c: { :"0" => {
        a: { :"0" => { name: 'profile_preference_personal_partners_sex_is_female' } },
        p: 'eq',
        v: { :"0" => { value: true } },
      }
    } } } }
    assert_response :success
    assert all_users_are &want_female
    assert all_users.count > 0

    # post :search, query: { personal_partners_sex_multiselect: %w(male) }
    post :search, query: { g: {
      :"0" => { m: 'or', c: { :"0" => {
        a: { :"0" => { name: 'profile_preference_personal_partners_sex_is_male' } },
        p: 'eq',
        v: { :"0" => { value: true } },
      }
    } } } }
    assert_response :success
    assert all_users_are &want_male
    assert all_users.count > 0

    # post :search, query: { personal_partners_sex_multiselect: %w(male female) }
    post :search, query: { g: {
      :"0" => { m: 'or', c: { :"0" => {
        a: {
          :"0" => { name: 'profile_preference_personal_partners_sex_is_female' },
          :"1" => { name: 'profile_preference_personal_partners_sex_is_male' }
        },
        p: 'eq',
        v: {
          :"0" => { value: true },
          :"1" => { value: true }
        },
      }
    } } } }
    assert_response :success
    assert any_users_are &want_female
    assert any_users_are &want_male
    assert all_users.count > 0
  end

  test 'user should be able to filter by two or more multiselects' do
    post :search, query: { g: {
      :"0" => { m: 'or', c: { :"0" => {
        a: { :"0" => { name: 'profile_preference_personal_partners_sex_is_male' } },
        p: 'eq',
        v: { :"0" => { value: true } },
      }
    } },
      :"1" => { m: 'or', c: { :"0" => {
        a: { :"0" => { name: 'profile_preference_date_want_relationship_is_date' } },
        p: 'eq',
        v: { :"0" => { value: true } },
      }
    } } } }
    assert_response :success
    assert all_users_are &want_male
    assert all_users.count > 0
    assert all_users.all? { |e|
      e.profile.profile_preference.personal_want_relationship_is_date
    }
  end

  # tests range filters
  test 'user should be able to filter by age' do
    # somehow gteq and lteq for this ransacker are reversed, unable to track it down yet.
    post :search, query: { optional_info_age_gteq: 30, optional_info_age_lteq: 20 }
    assert_response :success
    assert all_users_are &aged_for((20..30).to_a)
    assert_equal 2, all_users.count
  end

  # test string filters
  test 'user should be able to filter by city' do
    post :search, query: { general_info_city_cont: 'iam' }
    assert_equal 3, all_users.count

    post :search, query: { general_info_city_cont: 'rivoy' }
    assert_equal 1, all_users.count
  end

  test 'user should not be able to see deleted users in search' do
    users(:mia).delete!
    get :index
    assert_equal 3, all_users.count
    assert all_users_are { |e| !e.deleted? }
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
    -> e { e.profile.personal_preferences_sex.to_s == 'female' }
  end

  def male
    -> e { e.profile.personal_preferences_sex.to_s == 'male' }
  end

  def want_female
    -> e {
      enum_include? e.published_profile.personal_partners_sex_multiselect, 'female'
    }
  end

  def want_male
    -> e {
      enum_include? e.published_profile.personal_partners_sex_multiselect, 'male'
    }
  end

  def in_range(distance)
    -> e { e.distance <= distance }
  end

  def aged_for(range)
    -> e { range.include? e.profile.optional_info_age }
  end

  def put
    -> e { puts e.name }
  end

  def enum_include?(subject, item)
    res = false
    subject.each do |subject_item|
      if subject_item.to_s == item.to_s
        res = true
      end
    end
    res
  end
end
