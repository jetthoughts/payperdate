require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  fixtures :users, :profiles, :block_relationships

  def setup
    @current_user = users(:martin)
    sign_in @current_user
  end

  test 'should not be able to see others user before current user fill profile' do
    sign_in users(:paul)
    get :show, user_id: users(:john)
    assert_redirected_to edit_profile_path
  end

  test 'should be able see own profile' do
    sign_in users(:paul)
    get :show, user_id: users(:paul)
    assert_redirected_to edit_profile_path
  end

  test 'should be not able to see others user without filled profile' do
    get :show, user_id: users(:john)
    assert_redirected_to root_path
  end

  test 'should be able to see others user profile' do
    get :show, user_id: users(:martin)
    assert_response :success
  end

  test 'should be able see others user with filled profile' do
    get :show, user_id: users(:john)
    assert_redirected_to root_path
  end

  test 'should not be able to see blocked user profile' do
    get :show, user_id: users(:lola)
    assert_redirected_to root_path
  end

  test 'should render block button when user is not blocked' do
    get :show, user_id: users(:ria)
    assert_select 'a', 'Block'
  end

  test 'should render unblock button when user is blocked' do
    users(:martin).block_user users(:ria)
    get :show, user_id: users(:ria)
    assert_select 'a', 'Unblock'
  end

  test 'should hide follow action for blocked user from blocker profile page' do
    sign_in users(:ria)
    get :show, user_id: users(:robert)
    assert_select 'a', { text: 'Follow', count: 0 }
    assert_select 'button', { text: 'Follow', count: 0 }
  end

  test 'should hide bookmark action for blocked user from blocker profile page' do
    sign_in users(:ria)
    get :show, user_id: users(:robert)
    assert_select 'a', { text: 'Bookmark', count: 0 }
    assert_select 'button', { text: 'Bookmark', count: 0 }
  end

  test 'should hide send gift action for blocked user from blocker profile page' do
    sign_in users(:ria)
    get :show, user_id: users(:robert)
    assert_select 'a', { text: 'Send gift', count: 0 }
    assert_select 'button', { text: 'Send gift', count: 0 }
  end

  test 'should hide invite action for blocked user from blocker profile page' do
    sign_in users(:ria)
    get :show, user_id: users(:robert)
    assert_select 'a', { text: 'Invite', count: 0 }
    assert_select 'button', { text: 'Invite', count: 0 }
  end

  test 'should hide wink action for blocked user from blocker profile page' do
    sign_in users(:ria)
    get :show, user_id: users(:robert)
    assert_select 'a', { text: 'Wink', count: 0 }
    assert_select 'button', { text: 'Wink', count: 0 }
  end

  test 'should hide follow action for blocker user from blocked profile page' do
    sign_in users(:robert)
    get :show, user_id: users(:ria)
    assert_select 'a', { text: 'Follow', count: 0 }
    assert_select 'button', { text: 'Follow', count: 0 }
  end

  test 'should hide bookmark action for blocker user from blocked profile page' do
    sign_in users(:robert)
    get :show, user_id: users(:ria)
    assert_select 'a', { text: 'Bookmark', count: 0 }
    assert_select 'button', { text: 'Bookmark', count: 0 }
  end

  test 'should render send gift action for blocker user from blocked profile page' do
    sign_in users(:robert)
    get :show, user_id: users(:ria)
    assert_select 'a', 'Send gift'
  end

  test 'should hide invite action for blocker user from blocked profile page' do
    sign_in users(:robert)
    get :show, user_id: users(:ria)
    assert_select 'a', { text: 'Invite', count: 0 }
    assert_select 'button', { text: 'Invite', count: 0 }
  end

  test 'should hide wink action for blocker user from blocked profile page' do
    sign_in users(:robert)
    get :show, user_id: users(:ria)
    assert_select 'a', { text: 'Wink', count: 0 }
    assert_select 'button', { text: 'Wink', count: 0 }
  end

  test 'show should redirect to page saying that user was deleted if user was deleted' do
    users(:sophia).delete!
    get :show, user_id: users(:sophia)
    assert_redirected_to root_path
    assert_equal 'Sorry, but this user was deleted', flash[:alert]
  end

  test 'should add viewers on view profiles' do
    mia = users(:mia)
    assert_difference [ -> { @current_user.viewed_users.count }, -> { mia.viewers.count }], +1 do
      get :show, user_id: mia
    end
  end

end
