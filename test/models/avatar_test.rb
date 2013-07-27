require 'test_helper'

class AvatarTest < ActiveSupport::TestCase
  fixtures :users, :profiles, :albums

  def test_create
    photo = create_sample_avatar
    assert_equal nil, photo.face
  end

  def test_validate_nudity
    FaceDetectorService.instance.face_result = false

    photo = create_sample_avatar

    photo.validate_image!

    assert_equal false, photo.face
  end

  def test_schedule_nudity_validation
    assert_difference -> { Delayed::Job.count }, +1 do
      create_sample_avatar.committed!
    end
  end

  private
  def create_sample_avatar
    Avatar.create! image: create_tmp_image, profile: profiles(:martins)
  end
end