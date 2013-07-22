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

  has_one :public_photo, conditions: { verified_status: VerifiedStatus.approved },
          foreign_key: :id, class_name: Photo

  validates :album, presence: true

  after_find :schedule_nudity_validation
  after_commit :schedule_nudity_validation, if: :just_created_and_commited_record?

  def approve!
    self.verified_status = VerifiedStatus.approved
    save!
  end

  def decline!
    self.verified_status = VerifiedStatus.declined
    save!
    notify_photo_was_declined
  end

  def nudity_detector_service
    NudityDetectorService.instance
  end

  def unapprove!
    return_to_pending
  end

  def undecline!
    return_to_pending
  end

  def approved?
    verified_status == VerifiedStatus.approved
  end

  def declined?
    verified_status == VerifiedStatus.declined
  end

  def validate_nudity!
    nude_status = nudity_detector_service.nude?(self.image.url)
    self.update! nude: nude_status, nudity: nude_status ? 1 : 0
  end

  def self.validate_nudity!
    where(nudity: nil).find_each(lock: true) do |photo|
      photo.validate_nudity!
    end
  end

  private

  def schedule_nudity_validation
    if nudity.blank?
      Photo.reset_callbacks :find
      ValidateNudityJob.create_delayed_job(self.id)
    end
  end

  def just_created_and_commited_record?
    created_at == updated_at
  end

  def return_to_pending
    self.verified_status = VerifiedStatus.pending
    save!
  end

  def notify_photo_was_declined
    NotificationMailer.photo_was_declined(user_id, image.url(:medium))
  end

end

