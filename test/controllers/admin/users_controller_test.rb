require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  def setup
    @controller = ::Admin::UsersController.new
  end

  fixtures :admin_users, :users, :profiles

  test 'master admin should have access to users' do
    sign_in admin_users(:admin)

    get :index
    assert_response :success
  end

  test 'non master admin should not have access to users' do
    sign_in admin_users(:john)

    get :index
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'non master admin should not have access to users even when allowed to approve photos' do
    sign_in admin_users(:james)

    get :index
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'customer care should have access to users' do
    sign_in admin_users(:bill)

    get :index
    assert_response :success
  end

  test 'customer care should not have access to edit user' do
    sign_in admin_users(:bill)

    get :edit, id: users(:martin).id
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'customer care should not have access to create user' do
    sign_in admin_users(:bill)

    get :new
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'customer care should be able to block user' do
    sign_in admin_users(:bill)

    put :block, id: users(:martin).id
    assert_redirected_to admin_users_path

    assert_equal true, User.find(users(:martin).id).blocked
  end

  test 'non master admin should not be able to block user' do
    sign_in admin_users(:james)

    put :block, id: users(:martin).id
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'blocked user should receive email about that' do
    sign_in admin_users(:bill)

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      put :block, id: users(:mia).id
      assert_redirected_to admin_users_path
    end

    blocked_notification = ActionMailer::Base.deliveries.last

    assert_equal 'Your account has been blocked', blocked_notification.subject
    assert_equal users(:mia).email, blocked_notification.to[0]
    assert_match /your account was blocked/, blocked_notification.body.to_s
  end

  test 'non master admin should not be able delete users' do
    sign_in admin_users(:james)

    delete :delete, id: users(:martin).id
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'customer care should be able to delete user' do
    sign_in admin_users(:bill)

    delete :delete, id: users(:martin).id
    assert_redirected_to admin_users_path

    assert_equal [], User.where(id: users(:martin).id)
  end

  test 'deleted user should receive notification' do
    sign_in admin_users(:bill)

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      delete :delete, id: users(:mia).id
      assert_redirected_to admin_users_path
    end

    deleted_notification = ActionMailer::Base.deliveries.last

    assert_equal 'Your account has been deleted', deleted_notification.subject
    assert_equal users(:mia).email, deleted_notification.to[0]
    assert_match /your account was deleted/, deleted_notification.body.to_s
  end
end
