class Avatar < Photo
  PREFERRED_ALBUM = 'Avatars'

  before_validation :find_album

  def validate_image!
    validate_face if face.nil?
    super
  end

  def public_photo
    self.becomes(Photo) if approved?
  end

  private

  def validate_face
    self.face = FaceDetectorService.face?(image)
  end

  def find_album
    return if album.present?

    self.album = profile.user.albums.where(name: PREFERRED_ALBUM).first_or_create(system: true)
  end

end
