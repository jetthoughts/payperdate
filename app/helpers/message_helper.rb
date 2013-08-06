module MessageHelper

  def message_received_by_user?(message, user)
    message.recipient_id == user.id
  end

  def message_sent_by_user?(message, user)
    message.sender_id == user.id
  end

  def message_unread_by_user?(message, user)
    message_received_by_user?(message, user) && message.unread?
  end

  def other_user_of_message(message, user)
    if message.recipient_id == user.id
      message.sender
    else
      message.recipient
    end
  end

end
