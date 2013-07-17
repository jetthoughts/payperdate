require 'nude'

module NudityDetectorService
  class NudeImpl
    def nude?(image_path)
      if Rails.env.development?
        image_path = "public/#{image_path}"
      end
      Nude.nude?(image_path)
    end
  end
end