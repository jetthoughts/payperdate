class Photo < ActiveRecord::Base
  require 'payperdate/act_as_enumeration'
  require 'payperdate/file_size_validator'
  belongs_to :album
  mount_uploader :image, ImageUploader
  validates :image,
            presence:  true,
            file_size: {
                maximum: 5.megabytes.to_i
            }

  delegate :user_id, to: :album, allow_nil: true

  STATUSES = { pending: 0, approved: 1, declined: 2 }

  class VerifiedStatus
    extend ActAsEnumeration
    act_as_enumeration(STATUSES)
  end
  VerifiedStatus.labels.each { |k, v| define_method "#{v}?", -> { status == k } }

  scope :approved, -> { where(verified_status: VerifiedStatus.approved) }

  validates :album, presence: true
end

