class NotificationMailer < ActionMailer::Base
  default from: 'support@payperdate.com'

  def photo_was_declined(user_id, photo_url)
    @user = User.find(user_id)
    @photo_url = photo_url
    mail(to: user.email, subject: 'Your photo has been declined')
  end

end
