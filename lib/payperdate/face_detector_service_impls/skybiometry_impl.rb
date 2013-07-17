require 'face'

module FaceDetectorService
  class SkybiometryImpl
    include ActiveSupport::Configurable
    config_accessor :api_key, :api_secret

    def initialize
      @client = Face.get_client(api_key: api_key, api_secret: api_secret)
    end

    def face?(uploader)
      face_detections = faces_detect(uploader)
      face_detections['status'] == 'success' && face_detections['photos'].first['tags'].present?
    end

    def faces_detect(uploader)
      options = {}

      unless uploader.path
        options[:urls] = [uploader.url]
      else
        options[:file] = File.new(uploader.path)
      end

      @client.faces_detect(options)
    end
  end
end