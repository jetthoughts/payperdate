class Gift < ActiveRecord::Base
  belongs_to :gift_template
  belongs_to :user
  belongs_to :recipient, class_name: 'User'

  validates :gift_template, :user, :recipient, presence: true
  validate :validate_user_can_send_for_self
  validate :validate_user_can_send_disabled_gift
  validate :validate_user_can_send_to_blocker

  validate :validate_user_credits_amount

  delegate :image_url, :name, to: :gift_template

  after_create :tracked_send_gift

  def to_s
    name
  end

  private

  def validate_user_credits_amount
    self.errors.add(:base, :cant_send_gift_with_this_price) if user.credits_amount < self.gift_template.cost
  end

  def validate_user_can_send_for_self
    self.errors.add(:base, :cant_send_gift_to_self) if user == recipient
  end

  def validate_user_can_send_disabled_gift
    self.errors.add(:base, :cant_send_disabled_gifts) if gift_template and gift_template.disabled?
  end

  def validate_user_can_send_to_blocker
    self.errors.add(:base, :cant_send_gift_to_blocker) if user.blocked_for?(recipient)
  end

  def tracked_send_gift
    transaction = ::Transaction.create key: 'send_gift',
      recipient: recipient,
      trackable: self,
      amount: -self.gift_template.cost,
      owner: user

    transaction.purchase
  end
end
