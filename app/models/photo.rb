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

  after_create :schedule_nudity_validation

  def approve!
    self.verified_status = VerifiedStatus.approved
    save!
  end

  def decline!
    self.verified_status = VerifiedStatus.declined
    save!
    NotificationMailer.delay.photo_was_declined(user_id, image.url(:medium))
  end

  def validate_nudity!
    self.image.cache!
    raise 'image should be cached before testing nudity' unless self.image.cached?
    nude_status = nudity_detector_service.nude?(self.image.path)
    self.update! nude: nude_status, nudity: nude_status ? 1 : 0
  end

  def self.validate_nudity!
    where(nudity: nil).find_each(lock: true) do |photo|
      photo.validate_nudity!
    end
  end

  def nudity_detector_service
    NudityDetectorService.instance
  end

  private
  def schedule_nudity_validation
    Delayed::Job.enqueue ValidateNudityJob.new(self.id)
  end
end

