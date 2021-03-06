require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  self.use_transactional_fixtures = false

  fixtures :albums, :users

  def test_create
    photo = create_sample_photo

    refute_predicate photo, :nude?
  end

  def test_validate_nudity
    NudityDetectorService.instance.nude = true

    photo = create_sample_photo

    photo.validate_image!

    assert_predicate photo, :nude?
  end

  def test_schedule_nudity_validation
    assert_difference -> { Delayed::Job.count }, +1 do
      create_sample_photo.committed!
    end
  end

  private

  def create_sample_photo
    Photo.create! image: create_tmp_image, album: albums(:favorites)
  end
end
