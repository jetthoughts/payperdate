require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  fixtures :users, :profiles, :profile_multiselects, :albums
  photos_and_avatars_fixtures

  setup do
    sign_in users(:martin)
  end

  test 'index action' do
    get :index, album_id: albums(:favorites)
    assert_response :success
    assert_equal 3, assigns(:photos).count
  end

  test 'index action should not track any activity' do
    assert_difference -> { Activity.count }, 0 do
      get :index, album_id: albums(:favorites)
    end
  end

  test 'create action' do
    assert_difference -> { Photo.count }, +1 do
      post :create, album_id: albums(:favorites),
           photo: { image: build_upload_for(create_tmp_image) }, format: :js
      assert_response :success
    end

    assert_equal Photo.last.id, assigns(:photo).id
  end

  test 'create action should track activity' do
    assert_difference -> { Activity.count }, +1 do
      post :create, album_id: albums(:favorites),
           photo: { image: build_upload_for(create_tmp_image) }, format: :js
    end

    created_photo_activity = users(:martin).activities.last
    assert_equal profiles(:martins), created_photo_activity.subject
    assert_equal 'create_photo', created_photo_activity.action
  end

  test 'destroy action' do
    assert_difference -> { Photo.count }, -1 do
      delete :destroy, album_id: photos(:two).album, id: photos(:two), format: :js
      assert_response :success
    end

    assert_equal photos(:two).id, assigns(:photo).id
  end

  test 'destroy action should track activity' do
    assert_difference -> { Activity.count }, +1 do
      delete :destroy, album_id: photos(:two).album, id: photos(:two), format: :js
    end

    destroyed_photo_activity = users(:martin).activities.last
    assert_equal profiles(:martins), destroyed_photo_activity.subject
    assert_equal 'destroy_photo', destroyed_photo_activity.action
  end

  test 'use as avatar action' do
    post :use_as_avatar, id: avatars(:another), album_id: avatars(:another).album
    assert_response :success
    assert_equal avatars(:another).id, users(:martin).reload.avatar_id
  end

  test 'use as avatar action should track activity' do
    assert_difference -> { Activity.count }, +1 do
      post :use_as_avatar, id: avatars(:another), album_id: avatars(:another).album
    end

    used_avatar_activity = users(:martin).activities.last
    assert_equal profiles(:martins), used_avatar_activity.subject
    assert_equal 'use_as_avatar_photo', used_avatar_activity.action
  end
end
