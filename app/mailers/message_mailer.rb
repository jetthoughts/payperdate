class MessageMailer < BaseMailer

  def new_message(message_id)
    @message = Message.find(message_id)
    return unless @message.recipient.settings.notify_message_received?
    mail(to: @message.recipient.email, subject: t('messages.mailer.message_received'))
  end

end
