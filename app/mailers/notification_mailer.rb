class NotificationMailer < BaseMailer
  def photo_was_declined(user_id, photo_url)
    @user = User.find(user_id)
    @photo_url = photo_url
    deliver_mail mail(to: @user.email, subject: 'Your photo has been declined')
  end

  def review_status_changed(user_id, status)
    @user = User.find(user_id)
    @status = status
    deliver_mail mail(to: @user.email, subject: 'Review status of your profile has been changed')
  end

  def user_was_blocked(user_id)
    @user = User.find(user_id)
    deliver_mail mail(to: @user.email, subject: 'Your account has been blocked')
  end

  def user_was_deleted(email, name)
    @name = name
    deliver_mail mail(to: email, subject: 'Your account has been deleted')
  end

  def user_was_restored(email, name)
    @name = name
    deliver_mail mail(to: email, subject: 'Your account has been restored')
  end

  private

  def deliver_mail(mail)
    if Payperdate::Application.config.background_workers_envs.include? Rails.env && !Rails.env.test?
      mail
    else
      mail.deliver
    end
  end
end
