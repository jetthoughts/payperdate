require 'payperdate/service_singleton'

require 'payperdate/nudity_detector_service_impls/nude_impl'
require 'payperdate/nudity_detector_service_impls/test_impl'

module NudityDetectorService
  class << self
    include ServiceSingleton

    def instance
      @instance = NudityDetectorService::NudeImpl.new unless defined?(@instance)
      super
    end

    private
    def build_impl(impl)
      "NudityDetectorService::#{impl.to_s.camelize}Impl".constantize.new
    end
  end
end