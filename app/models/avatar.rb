class Avatar < Photo
  PREFERRED_ALBUM = 'Avatars'

  before_validation :find_album

  scope :avatars, -> {
    joins(:profile).where('profiles.avatar_id = photos.id')
  }

  scope :pending, -> { Photo.pending.avatars }
  scope :approved, -> { Photo.approved.avatars }
  scope :declined, -> { Photo.declined.avatars }

  private

  def find_album
    return if album.present?

    self.album = profile.user.albums.where(name: PREFERRED_ALBUM).first_or_create(system: true)
  end
end
