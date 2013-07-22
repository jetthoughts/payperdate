require 'test_helper'

class FaceDetectorServiceTest < ActiveSupport::TestCase
  def test_respond_to_face
    FaceDetectorService.face?('test')
  end
end