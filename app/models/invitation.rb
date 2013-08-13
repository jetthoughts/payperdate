class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :invited_user, class_name: 'User'

  validates :user, :invited_user, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_user_can_invite_himself
  validate :validate_user_can_blocked_by_self
  validate :validate_user_can_blocker
  validate :validate_already_sent, on: :create

  after_commit :notify_recipient, on: :create

  state_machine :state, :initial => :pending do
    event :accept do
      transition pending: :accepted
    end
    event :reject do
      transition pending: :rejected
    end

    after_transition pending: :accepted do |invitation, transition|
      InvitationMailer.delay.invitation_was_accepted(invitation.id)
    end

    after_transition pending: :rejected do |invitation, transition|
      InvitationMailer.delay.invitation_was_rejected(invitation.id)
    end

  end

  def self.existing_states
    Invitation.state_machines[:state].states.map(&:value)
  end

  existing_states.each do |scope_name|
    scope scope_name, -> { where(state: scope_name) }
  end

  def reject_by_reason(reason = nil)
    self.reject_reason = reason
    self.reject
  end

  def make_counter_offer(new_amount)
    if new_amount != amount
      self.amount  = new_amount
      self.counter = true
      res = self.save
      notify_recipient
      res
    end
  end

  def can_be_countered_by?(u)
    pending? && !counter && invited_user == u
  end

  def can_be_rejected_by?(u)
    pending? && (((user == u) && counter) || ((invited_user == u) && !counter))
  end

  def can_be_accepted_by?(u)
    pending? && (((user == u) && counter) || ((invited_user == u) && !counter))
  end

  def can_be_deleted_by?(u)
    pending? && (user == u) && !counter
  end

  def inviter
    counter ? invited_user : user
  end

  def recipient
    friend(inviter)
  end

  def friend(cur_user)
    cur_user == user ? invited_user : user
  end

  private

  def validate_user_can_invite_himself
    self.errors.add(:invited_user_id, :cant_invite_himself) if user.operate_with_himself?(invited_user)
  end

  def validate_user_can_blocked_by_self
    self.errors.add(:invited_user_id, :cant_invite_blocked) if invited_user.blocked_for?(user)
  end

  def validate_user_can_blocker
    self.errors.add(:invited_user_id, :cant_invite_blocker) if user.blocked_for?(invited_user)
  end


  def validate_already_sent
    self.errors.add(:invited_user_id, :already_sent) if user.already_invited?(invited_user)
  end

  def notify_recipient
    if counter
      InvitationMailer.delay.counter_invitation(self.id)
    else
      InvitationMailer.delay.new_invitation(self.id)
    end
  end

end
