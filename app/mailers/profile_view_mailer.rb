class ProfileViewMailer < BaseMailer

  def profile_viewed(profile_view_id)
    @profile_view = ProfileView.find(profile_view_id)
    return unless @profile_view.viewed.settings.notify_profile_viewed?
    mail(to: @profile_view.viewed.email, subject: t('profile_view.mailer.profile_viewed'))
  end

end
