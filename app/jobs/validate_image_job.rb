class ValidateImageJob < Struct.new(:photo_id)

  def perform
    Photo.find(photo_id).validate_image!
  end

end