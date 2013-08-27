module MessageHelper

  def message_unread_by_user?(message, user)
    message.received_by?(user) && message.unread?
  end

end
