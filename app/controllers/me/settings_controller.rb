class Me::SettingsController < BaseController

  before_filter :load_user_settings

  def edit
  end

  def update
    @settings.update settings_attributes
    redirect_to edit_settings_path, notice: t('settings.saved')
  end

  private

  def load_user_settings
    @settings = current_user.settings
  end

  def settings_attributes
    params.required(:user_setting).permit(:notify_invitation_received, :notify_invitation_responded,
                                          :notify_message_received, :notify_added_to_favorites,
                                          :notify_profile_viewed)
  end

end
