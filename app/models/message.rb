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

  scope :by, ->(user) { where { sift :sent_or_received_by, user } }
  scope :unread, -> { where recipient_state: 'unread' }
  scope :received_by, ->(user) { where { sift :received_and_not_deleted, user  } }
  scope :sent_by, ->(user) { where { sift :sent_and_not_deleted, user } }

  validates :sender, :recipient, presence: true
  validates :content, presence: true

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

  def received_by?(user)
    recipient_id == user.id
  end

  def sent_by?(user)
    sender_id == user.id
  end

  def deleted_by?(user)
    if received_by?(user)
      self.deleted_by_recipient?
    elsif sent_by?(user)
      self.deleted_by_sender?
    else
      false
    end
  end

  def delete_by(user)
    if received_by?(user)
      self.delete_by_recipient
    elsif sent_by?(user)
      self.delete_by_sender
    else
      false
    end
  end

end
