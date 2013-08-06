# encoding: utf-8

class ImageUploader < BaseUploader
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/photos/#{mounted_as}/#{model.id}"
  end

  version :medium do
    process resize_to_fit: [100, 100]
  end


  version :avatar, if: :is_avatar? do
    process resize_to_fit: [200, 300]
  end

  version :thumb, if: :is_avatar? do
    process resize_to_fill: [50, 50]
  end

  def default_url
    '/images/fallback/' + [version_name, 'default.png'].compact.join('_')
  end

  protected

  def is_avatar?(new_file)
    model.avatar?
  end

end
