require 'test_helper'

class Admin::AvatarsControllerTest < ActionController::TestCase
  def setup
    profiles(:martins).update(avatar: create_sample_avatar)
    profiles(:mias).update(avatar: create_sample_avatar)
    @controller = ::Admin::AvatarsController.new
  end

  fixtures :admin_users
  fixtures :users
  fixtures :profiles

  test 'master admin should have access to avatars' do
    sign_in admin_users(:admin)

    get :index
    assert_response :success
  end

  test 'non master admin should not have access to avatars' do
    sign_in admin_users(:john)

    get :index
    assert_redirected_to admin_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:error]
  end

  test 'non master admin should have access to avatars if allowed to approve photos' do
    sign_in admin_users(:james)

    get :index
    assert_response :success
  end

  private

  def create_sample_avatar
    Avatar.create! image: create_tmp_image, album: albums(:favorites)
  end

  def create_tmp_image
    Tempfile.new(%w(example .jpg)).tap { |f| f.puts('stub image file body') }
  end
end


