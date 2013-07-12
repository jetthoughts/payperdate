class Photo < ActiveRecord::Base
  require 'payperdate/act_as_enumeration'
  require 'payperdate/file_size_validator'
  belongs_to :album
  has_one :profile, foreign_key: :avatar_id

  mount_uploader :image, ImageUploader
  validates :image,
            presence:  true,
            file_size: {
                maximum: 5.megabytes.to_i
            }

  delegate :user_id, :user, to: :album, allow_nil: true

  STATUSES = { pending: 0, approved: 1, declined: 2 }

  class VerifiedStatus
    extend ActAsEnumeration
    act_as_enumeration(STATUSES)
  end
  VerifiedStatus.labels.each { |k, v| define_method "#{v}?", -> { status == k } }

  scope :pending, -> { where(verified_status: VerifiedStatus.pending) }
  scope :approved, -> { where(verified_status: VerifiedStatus.approved) }
  scope :declined, -> { where(verified_status: VerifiedStatus.declined) }

  validates :album, presence: true

  def approve!
    self.verified_status = VerifiedStatus.approved
    save!
  end

  def decline!
    self.verified_status = VerifiedStatus.declined
    save!
    NotificationMailer.delay.photo_was_declined(user_id, image.url(:medium))
  end

end

