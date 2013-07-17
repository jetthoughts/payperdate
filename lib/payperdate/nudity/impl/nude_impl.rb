require 'nude'

module NudityDetectorService
  class NudeImpl
    def nude?(image_path)
      Nude.nude?(image_path)
    end
  end
end