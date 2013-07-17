require 'test_helper'

class NudityDetectorServiceTest < ActiveSupport::TestCase
  def test_nude_should_accept_image_path
    NudityDetectorService.nude?('test')
  end
end