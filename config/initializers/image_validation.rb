require 'payperdate/face_detector_service'
require 'payperdate/nudity_detector_service'

unless Rails.env.test?
  FaceDetectorService::SkybiometryImpl.configure do |config|
    config.api_key    = Settings.skybiometry.api_key
    config.api_secret = Settings.skybiometry.api_secret
  end
else
  NudityDetectorService.instance = :test
  FaceDetectorService.instance   = :test
end