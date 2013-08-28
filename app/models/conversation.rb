class Conversation

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  delegate :id, to: :interlocutor

  def self.by_user(user)
    messages = Message.by(user).includes(:sender, :recipient)
    messages.map { |message| Conversation.new(user, message.interlocutor(user)) }.uniq
  end

  def self.by_users(viewer, interlocutor)
    return nil if viewer == interlocutor
    Conversation.new(viewer, interlocutor)
  end

  attr_reader :viewer, :interlocutor

  def has_unread?
    unread_count > 0
  end

  def unread_count
    @unread_count ||= unread.count
  end

  def last_message
    messages.last
  end

  def unread_message?(message)
    message.received_by?(viewer) && message.unread?
  end

  def read_all!
    unread.each do |message|
      message.read! if viewer.can_access? message
    end
  end

  def unread
    messages.received_by(viewer).unread
  end

  def messages
    Message.between(@viewer, @interlocutor).reverse_order
  end

  def append(content)
    Message.create sender: viewer, recipient: interlocutor, content: content
  end

  def hash
    id
  end

  def eql?(other)
    hash.eql?(other.hash)
  end

  def persisted?
    true
  end

  private

  def initialize(viewer, interlocutor)
    @viewer = viewer
    @interlocutor = interlocutor
  end

end
