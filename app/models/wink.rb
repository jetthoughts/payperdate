class Wink < ActiveRecord::Base
  belongs_to :wink_template

  belongs_to :recipient, class_name: 'User'
  belongs_to :user

  validates :wink_template, :user, :recipient, presence: true
  validate :validate_user_wink_himself
  validate :validate_user_wink_blocked_by_himself
  validate :validate_user_wink_blocker
  validate :validate_user_wink_twice, on: :create
  delegate :image, to: :wink_template

  after_commit :notify_recipient, on: :create

  private

  def users_set?
    user && recipient
  end

  def validate_user_wink_himself
    self.errors.add(:recipient_id, :cant_wink_himself) if users_set? && user.operate_with_himself?(recipient)
  end

  def validate_user_wink_twice
    self.errors.add(:recipient_id, :cant_wink_twice_for_day) if users_set? && user.already_winked?(recipient)
  end

  def validate_user_wink_blocked_by_himself
    self.errors.add(:recipient_id, :cant_wink_blocked) if users_set? && recipient.blocked_for?(user)
  end

  def validate_user_wink_blocker
    self.errors.add(:recipient_id, :cant_wink_blocker) if users_set? && user.blocked_for?(recipient)
  end

  def notify_recipient
    WinkMailer.delay.new_wink(self.id)
  end

end
