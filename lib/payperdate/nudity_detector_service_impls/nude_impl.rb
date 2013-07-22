require 'nude'

module NudityDetectorService
  class NudeImpl
    def nude?(uploader)
      Nude.nude?(uploader.path || uploader.url)
    end
  end
end