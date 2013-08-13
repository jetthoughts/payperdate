module MessageHelper

  def message_received_by_user?(message, user)
    message.received_by?(user)
  end

  def message_sent_by_user?(message, user)
    message.sent_by?(user)
  end

  def message_unread_by_user?(message, user)
    message.received_by?(user) && message.unread?
  end

  def other_user_of_message(message, user)
    if message.recipient_id == user.id
      message.sender
    else
      message.recipient
    end
  end

end
