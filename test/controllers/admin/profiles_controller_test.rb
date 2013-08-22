require 'test_helper'

class Admin::ProfilesControllerTest < ActionController::TestCase
  def setup
    @controller = ::Admin::ProfilesController.new
  end

  fixtures :admin_users, :users, :profiles, :profile_preferences
  self.use_transactional_fixtures = false

  test 'admin should be able to view users profile' do
    sign_in admin_users(:admin)

    get :show, id: profiles(:martins)
    assert_response :success
  end

  test 'master admin should be able to see buttons block' do
    sign_in admin_users(:admin)

    get :show, id: profiles(:martins)
    assert_select 'a', 'Block'
    refute_select 'a', 'Unblock'
  end

  test 'master admin should be able to see button unblock' do
    sign_in admin_users(:admin)

    users(:martin).block!

    get :show, id: profiles(:martins)
    refute_select 'a', 'Block'
    assert_select 'a', 'Unblock'
  end

  test 'customer care should be able to see button block' do
    sign_in admin_users(:bill)

    get :show, id: profiles(:martins)
    assert_select 'a', 'Block'
    refute_select 'a', 'Unblock'
  end

  test 'customer care should be able to see button unblock' do
    sign_in admin_users(:bill)

    users(:martin).block!

    get :show, id: profiles(:martins)
    assert_select 'a', 'Unblock'
    refute_select 'a', 'Block'
  end

  test 'non customer care should not be able to see button block' do
    sign_in admin_users(:james)

    get :show, id: profiles(:martins)
    refute_select 'a', 'Block'
    refute_select 'a', 'Unblock'
  end

  test 'non customer care should not be able to see button unblock' do
    sign_in admin_users(:james)

    users(:martin).block!

    get :show, id: profiles(:martins)
    refute_select 'a', 'Unblock'
    refute_select 'a', 'Block'
  end
end
