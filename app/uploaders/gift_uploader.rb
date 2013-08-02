# encoding: utf-8

class GiftUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/gifts/#{mounted_as}/#{model.id}"
  end

  version :medium do
    process resize_to_fit: [100, 100]
  end

  version :thumb do
    process resize_to_fill: [50, 50]
  end

  def default_url
    '/images/fallback/' + [version_name, 'default.png'].compact.join('_')
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
