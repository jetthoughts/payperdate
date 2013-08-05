class WinkTemplate < ActiveRecord::Base
  require 'payperdate/file_size_validator'
  mount_uploader :image, WinkTemplateUploader
  scope :enabled, -> { where(disabled: false) }
  scope :disabled, -> { where(disabled: true) }

  validates :image, presence: true, file_size: { maximum: 1.megabytes.to_i }
  validates :name, presence: true, uniqueness: true

  def disable!
    update_column :disabled, true
  end

  def enable!
    update_column :disabled, false
  end
end
