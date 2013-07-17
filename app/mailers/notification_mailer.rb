class NotificationMailer < ActionMailer::Base
  default from: 'support@payperdate.com'

  def photo_was_declined(user_id, photo_url)
    deliver_email(:deliver_photo_was_declined, user_id, photo_url)
  end

  private
  
  def deliver_email(what, *args)
    if Payperdate::Application.config.background_workers_envs.include? Rails.env 
      send_background what, *args
    else
      send_now what, *args
    end
  end

  def deliver_photo_was_declined(user_id, photo_url)
    @user = User.find(user_id)
    @photo_url = photo_url
    mail(to: @user.email, subject: 'Your photo has been declined')
  end

  def send_background(what, *args)
    delay.send(what, *args)
  end

  def send_now(what, *args)
    send(what, *args).deliver
  end

end
