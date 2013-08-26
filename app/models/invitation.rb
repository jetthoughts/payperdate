class Invitation < ActiveRecord::Base
  monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :user
  belongs_to :invited_user, class_name: 'User'

  has_many :date_ranks, inverse_of: :invitation

  validates :user, :invited_user, presence: true
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
      UsersCommunication.create!(owner: invitation.user, recipient: invitation.invited_user)
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

  def can_be_unlocked_by?(u)
    accepted? && user == u && communications && !communications.unlocked?
  end

  # methods for ranking/showing rank accepted invitation (date)

  def rank_by(u)
    date_ranks.where(user_id: u).first
  end

  def ranked?(u)
    rank_by(u) != nil
  end

  def can_be_ranked?(u)
    accepted? && belongs_to_user?(u) && !ranked?(u)
  end

  def can_view_rank?(u)
    belongs_to_user?(u) && ranked?(u)
  end

  # end ranking methods

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

  def unlock
    if user.credits_amount > communication_cost
      users_communication = communications
      users_communication.unlock
    else
      self.errors.add(:base, :cant_unlocked_invitation)
    end
    errors.empty?
  end


  def friend(cur_user)
    cur_user == user ? invited_user : user
  end

  def belongs_to_user?(cur_user)
    cur_user == user || cur_user == invited_user
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

  def validate_user_credits_amount_to_unlock_communication
    self.errors.add(:base, :cant_unlocked_invitation) if user.credits_amount < communication_cost
  end

  def notify_recipient
    if counter
      InvitationMailer.delay.counter_invitation(self.id)
    else
      InvitationMailer.delay.new_invitation(self.id)
    end
  end

  def communication_cost
    @communication_cost ||= CommunicationCost.get(amount).cost
  end

  def communications
    UsersCommunication.find_by_users user, invited_user
  end
end
