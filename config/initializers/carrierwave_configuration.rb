require 'carrierwave/orm/activerecord'

case Rails.env
  when 'test'
    CarrierWave.configure do |config|
      config.storage           = :file
      config.enable_processing = false
    end
  when 'development'
    CarrierWave.configure do |config|
      config.permissions           = 0666
      config.directory_permissions = 0777
      config.storage               = :file
    end
  when 'staging'
    module Cloudinary::CarrierWave
      alias old_cache! cache!

      def cache!(new_file = sanitized_file)
        old_cache!(new_file)
      end
    end

    class ImageUploader < CarrierWave::Uploader::Base
      include Cloudinary::CarrierWave
    end
  else
    CarrierWave.configure do |config|
      config.fog_credentials = {
        provider:              'AWS', # required
        aws_access_key_id:     Settings.aws_access_key_id, # required
        aws_secret_access_key: Settings.aws_secret_access_key, # required
        region:                'us-east-1' # required
      }
      config.fog_directory   = Settings.s3_bucket
      config.fog_public      = true                                       # optional, defaults to true
      config.fog_attributes  = { 'Cache-Control' => 'max-age=315576000' } # optional, defaults to {}
      config.storage         = :fog
    end
end