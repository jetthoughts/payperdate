class Message < ActiveRecord::Base

  belongs_to :sender, class_name: 'User', inverse_of: :messages_sent
  belongs_to :recipient, class_name: 'User', inverse_of: :messages_received

  sifter :sent_and_not_deleted do |user_id|
    sender_id.eq(user_id) & sender_state.not_eq('deleted_by_sender')
  end

  sifter :received_and_not_deleted do |user_id|
    recipient_id.eq(user_id) & recipient_state.not_eq('deleted_by_recipient')
  end

  sifter :sent_or_received_by do |user|
    sift(:sent_and_not_deleted, user) | sift(:received_and_not_deleted, user)
  end

  sifter :all_sent_or_received_by do |user|
    sender_id.eq(user) | recipient_id.eq(user)
  end

  default_scope { order('created_at DESC') }
  scope :by, ->(user) { where { sift :sent_or_received_by, user } }
  scope :unread, -> { where recipient_state: 'unread' }
  scope :received_by, ->(user) { where { sift :received_and_not_deleted, user  } }
  scope :sent_by, ->(user) { where { sift :sent_and_not_deleted, user } }

  scope :between, ->(viewer, interlocutor) do
    where do
      sift(:sent_or_received_by, viewer) & sift(:all_sent_or_received_by, interlocutor)
    end
  end

  validates :sender, :recipient, :content, presence: true
  validate :validate_can_send_to_himself, on: :create
  validate :validate_can_send_to_blocker, on: :create

  state_machine :recipient_state, initial: :unread do
    event :read do
      transition unread: :read
    end

    event :delete_by_recipient do
      transition all => :deleted_by_recipient
    end
  end

  state_machine :sender_state, initial: :sent do
    event :delete_by_sender do
      transition all => :deleted_by_sender
    end
  end

  def users_date
    UsersDate.find_by_users(recipient, sender)
  end

  def interlocutor(user)
    sender == user ? recipient : sender
  end

  def received_by?(user)
    recipient_id == user.id
  end

  def sent_by?(user)
    sender_id == user.id
  end

  def deleted_by?(user)
    received_by?(user) ? deleted_by_recipient? : deleted_by_sender?
  end

  def belongs_to_user?(user)
    received_by?(user) || sent_by?(user)
  end

  def delete_by(user)
    false unless belongs_to_user?(user)
    received_by?(user) ? delete_by_recipient : delete_by_sender
  end

  private

  def validate_can_send_to_himself
    self.errors.add(:recipient_id, :cant_send_message_to_himself) if recipient == sender
  end

  def validate_can_send_to_blocker
    self.errors.add(:recipient_id, :cant_send_message_to_blocker) if sender && sender.blocked_for?(recipient)
  end

end
