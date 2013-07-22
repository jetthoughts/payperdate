require 'test_helper'

class NudityDetectorServiceTest < ActiveSupport::TestCase
  def test_respond_to_nude
    NudityDetectorService.nude?('test')
  end
end