require 'payperdate/service_singleton'

require 'payperdate/face_detector_service_impls/skybiometry_impl'
require 'payperdate/face_detector_service_impls/test_impl'

module FaceDetectorService
  class << self
    include ServiceSingleton

    def instance
      @instance = FaceDetectorService::SkybiometryImpl.new unless defined?(@instance)
      super
    end

    def build_impl(impl)
      "FaceDetectorService::#{impl.to_s.capitalize}Impl".constantize.new
    end
  end
end