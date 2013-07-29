require 'test_helper'

class AvatarsControllerTest < ActionController::TestCase
  fixtures :users, :profiles, :avatars

  def setup
    sign_in users(:martin)
  end

  def test_create_tracks_activity
    assert_difference -> { Activity.count }, +1 do
      post :create, avatar: { image: build_upload_for(create_tmp_image) }, format: :js
    end

    uploaded_avatar_activity = users(:martin).activities.last
    assert_equal profiles(:martins), uploaded_avatar_activity.subject
    assert_equal 'create_avatar', uploaded_avatar_activity.action
  end

  def test_destroy_tracks_activity
    assert_difference -> { Activity.count }, +1 do
      delete :destroy, id: avatars(:martins), format: :js
    end

    uploaded_avatar_activity = users(:martin).activities.last
    assert_equal profiles(:martins), uploaded_avatar_activity.subject
    assert_equal 'destroy_avatar', uploaded_avatar_activity.action
  end
end