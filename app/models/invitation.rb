class Invitation < ActiveRecord::Base
  monetize :amount_cents

  belongs_to :user
  belongs_to :invited_user, class_name: 'User'

  validates :user, :invited_user, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 5 }
  validate :validate_has_communication_cost
  validate :validate_user_can_invite_himself
  validate :validate_user_can_blocked_by_self
  validate :validate_user_can_blocker
  validate :validate_already_sent, on: :create

  after_commit :notify_recipient, on: :create

  state_machine :state, initial: :pending do
    event :accept do
      transition pending: :accepted
    end
    event :reject do
      transition pending: :rejected
    end

    after_transition pending: :accepted do |invitation, transition|
      unless UsersDate.find_by_users(invitation.user, invitation.invited_user)
        UsersDate.create(owner: invitation.user, recipient: invitation.invited_user)
      end
      InvitationMailer.delay.invitation_was_accepted(invitation.id)
    end

    after_transition pending: :rejected do |invitation, transition|
      InvitationMailer.delay.invitation_was_rejected(invitation.id)
    end

  end

  sifter :by_users do |user1, user2|
    (user_id == user1.id) & (invited_user_id == user2.id)
  end

  def self.existing_states
    Invitation.state_machines[:state].states.map(&:value)
  end

  def self.find_by_users(user1, user2)
    where{ sift(:by_users, user1, user2) | sift(:by_users, user2, user1) }.first
  end

  existing_states.each do |scope_name|
    scope scope_name, -> { where(state: scope_name) }
  end

  def accept_with_message(message)
    unless message.blank?
      Message.create!(sender: recipient, recipient: inviter, content: message)
    end
    accept
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
      InvitationMailer.delay.counter_invitation(self.id)
      res
    end
  end

  def need_response_from?(u)
    pending? && recipient == u
  end

  def can_be_countered_by?(u)
    !counter && need_response_from?(u)
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

  def belongs_to_user?(cur_user)
    cur_user == user || cur_user == invited_user
  end

  private

  def users_set?
    user && invited_user
  end

  def validate_user_can_invite_himself
    self.errors.add(:invited_user_id, :cant_invite_himself) if users_set? && user.operate_with_himself?(invited_user)
  end

  def validate_user_can_blocked_by_self
    self.errors.add(:invited_user_id, :cant_invite_blocked) if users_set? && invited_user.blocked_for?(user)
  end

  def validate_user_can_blocker
    self.errors.add(:invited_user_id, :cant_invite_blocker) if users_set? && user.blocked_for?(invited_user)
  end

  def validate_already_sent
    self.errors.add(:invited_user_id, :already_sent) if users_set? && user.already_invited?(invited_user)
  end

  def validate_has_communication_cost
    self.errors.add(:amount, :cant_find_communication_cost_for_amount) unless CommunicationCost.get(amount)
  end

  def notify_recipient
    InvitationMailer.delay.new_invitation(self.id)
  end

end
