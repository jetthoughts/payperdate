class Wink < ActiveRecord::Base
  belongs_to :wink_template

  belongs_to :recipient, class_name: 'User'
  belongs_to :user

  validates :wink_template, :user, :recipient, presence: true
  validate :validate_user_wink_himself
  validate :validate_user_wink_twice
  delegate :image, to: :wink_template

  after_commit :notify_recipient, on: :create

  private

  def validate_user_wink_himself
    self.errors.add(:recipient_id, :cant_wink_himself) if user.operate_with_himself?(recipient)
  end

  def validate_user_wink_twice
    self.errors.add(:recipient_id, :cant_wink_twice_for_day) if user.already_winked?(recipient)
  end

  def notify_recipient
    WinkMailer.delay.new_wink(self.id)
  end

end
