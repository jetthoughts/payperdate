require 'singleton'

require 'payperdate/nudity/impl/nude_impl'
require 'payperdate/nudity/impl/test_impl'

module NudityDetectorService
  mattr_reader :instance

  def self.instance=(impl)
    if Symbol === impl
      @@instance = "NudityDetectorService::#{impl.to_s.camelize}Impl".constantize.new
    else
      @@instance = impl
    end
  end

  delegate :nude?, to: :instance
  module_function :nude?
end