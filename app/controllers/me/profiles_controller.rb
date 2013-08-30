class Me::ProfilesController < BaseController
  before_filter :setup_user_and_profile
  before_filter :ensure_user_has_filled_profile, only: [:show]

  after_filter :track_activity, only: [:update]

  def show
  end

  def edit
  end

  def update
    if @profile.update profile_params
      flash[:notice] = I18n.t 'profiles.update.flash.notice.success'
      redirect_to me_path
    else
      flash[:alert] = I18n.t 'profiles.update.flash.alert.invalid'
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(Profile.editable_params)
  end

  def setup_user_and_profile
    @user    = current_user
    @profile = @user.profile
  end

  def track_activity
    current_user.track_profile_changed
  end
end
