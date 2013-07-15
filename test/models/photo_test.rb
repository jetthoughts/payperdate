require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  fixtures :albums, :users

  def test_create
    photo = create_sample_photo

    refute_predicate photo, :nude?
    assert_equal nil, photo.nudity
  end

  def test_validate_nudity
    NudityDetectorService.instance.nude = true

    photo = create_sample_photo

    photo.validate_nudity!

    assert_predicate photo, :nude?
    assert_equal 1, photo.nudity
  end

  def test_schedule_nudity_validation
    assert_difference -> { Delayed::Job.count }, +1 do
      Photo.create! image: create_tmp_image, album: albums(:favorites)
    end

  end

  private
  def create_sample_photo
    Photo.create! image: create_tmp_image, album: albums(:favorites)
  end

  def create_tmp_image
    Tempfile.new(%w(example .jpg)).tap { |f| f.puts('stub image file body') }
  end
end
