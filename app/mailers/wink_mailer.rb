class WinkMailer < BaseMailer
  def new_wink(wink_id)
    wink = Wink.find(wink_id)
    @recipient = wink.recipient
    mail(to: @recipient.email, subject: t('winks.mailer.new_wink'))
  end
end
