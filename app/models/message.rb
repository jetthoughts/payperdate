class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User', inverse_of: :messages_sent
  belongs_to :recipient, class_name: 'User', inverse_of: :messages_received

  sifter :sender_or_recipient_equal do |user_id|
    sender_id.eq(user_id) | recipient_id.eq(user_id)
  end

  scope :by, ->(user) { where { sift :sender_or_recipient_equal, user.id } }
  scope :unread, -> { where state: 'unread' }
  scope :received_by, ->(user) { where recipient_id: user }
  scope :sent_by, ->(user) { where sender_id: user }

  validates :sender, :recipient, presence: true
  validates :content, presence: true

  state_machine :state, initial: :unread do
    event :read do
      transition unread: :read
    end
  end

end
