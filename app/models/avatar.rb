class Avatar < Photo
  PREFERED_ALBUM = 'Avatars'

  before_validation :find_album

  private

  def find_album
    return if album.present?

    self.album = profile.user.albums.where(name: PREFERED_ALBUM).first_or_create(system: true)
  end
end