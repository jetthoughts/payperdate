class Gift < ActiveRecord::Base
  belongs_to :gift_template
  belongs_to :user
  belongs_to :recipient, class_name: 'User'

  validates :gift_template, :user, :recipient, presence: true
  validate :validate_user_can_send_for_self
  validate :validate_user_can_send_disabled_gift

  delegate :image_url, :name, to: :gift_template

  private

  def validate_user_can_send_for_self
    self.errors.add(:base, :cant_send_gift_to_self) if user == recipient
  end

  def validate_user_can_send_disabled_gift
    self.errors.add(:base, :cant_send_disabled_gifts) if gift_template and gift_template.disabled?
  end
end
