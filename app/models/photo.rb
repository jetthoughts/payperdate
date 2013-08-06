class Photo < ActiveRecord::Base
  require 'payperdate/act_as_enumeration'
  require 'payperdate/file_size_validator'

  belongs_to :album
  has_one :owner, foreign_key: :avatar_id, class_name: 'User', inverse_of: :avatar

  mount_uploader :image, ImageUploader
  validates :image, presence: true, file_size: { maximum: 5.megabytes.to_i }

  delegate :user_id, :user, to: :album, allow_nil: true

  VERIFIED_STATUSES = { pending: 0, approved: 1, declined: 2 }
  DECLINED_REASONS  = { by_unknown: nil, by_face: 1, by_nudity: 2 }

  class VerifiedStatus
    extend ActAsEnumeration
    act_as_enumeration(VERIFIED_STATUSES)
  end
  VerifiedStatus.labels.each { |k, v| define_method "#{v}?", -> { verified_status == k } }

  class DeclinedReason
    extend ActAsEnumeration
    act_as_enumeration(DECLINED_REASONS)
  end
  DeclinedReason.labels.each { |k, v| define_method "#{v}?", -> { status == k } }

  scope :pending, -> { where(verified_status: VerifiedStatus.pending) }
  scope :approved, -> { where(verified_status: VerifiedStatus.approved) }
  scope :declined, -> { where(verified_status: VerifiedStatus.declined) }
  scope :not_avatars, -> { where(type: 'Photo') }

  validates :album, presence: true

  after_commit :schedule_image_validation, on: :create

  def approve!
    self.update! verified_status: VerifiedStatus.approved
  end

  def decline!(by_reason = :by_unknown)
    self.update! verified_status: VerifiedStatus.declined,
                 declined_reason: DECLINED_REASONS[by_reason.to_sym]
    notify_photo_was_declined
  end

  def validate_image!
    validate_nudity
    save!
  end

  def self.validate_images!
    Photo.find_each do |photo|
      photo.validate_image!
    end
  end

  def avatar?
    type == 'Avatar'
  end

  def make_avatar
    return self if avatar?

    params = if image.url =~ /^http/
               { remote_image_url: image.url }
             else
               { image: image }
             end
    user.create_avatar!(params)
  end

  def can_be_used_as_avatar?
    if user
      user.avatar != self
    end
  end

  private

  def validate_nudity
    self.nude = NudityDetectorService.nude?(image) if self.nude.nil?
  end

  def schedule_image_validation
    Delayed::Job.enqueue ValidateImageJob.new(self.id)
  end

  def return_to_pending
    update! verified_status: VerifiedStatus.pending
  end

  def notify_photo_was_declined
    NotificationMailer.delay.photo_was_declined(user_id, image.url(:medium))
  end

end

