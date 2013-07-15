class ValidateNudityJob < Struct.new(:photo_id)
  def perform
    Photo.find(photo_id).validate_nudity!
  end
end