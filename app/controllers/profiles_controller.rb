class ProfilesController < BaseController
  before_filter :load_profile
  before_filter :ensure_user_has_filled_profile
  before_filter :require_filled_profile
  before_filter :check_if_user_is_blocked
  before_filter :check_if_user_is_deleted

  def show
    current_user.view_user @user
  end

  private

  def load_profile
    @user = User.find(params[:user_id])
    @profile = @user.published_profile
  end

  def check_if_user_is_blocked
    if @user.blocked?
      flash[:alert] = t 'users.errors.user_blocked'
      redirect_to root_path
    end
  end

  def check_if_user_is_deleted
    if @user.deleted?
      flash[:alert] = I18n.t('flash.profiles.deleted.alert')
      redirect_to root_path
    end
  end

  def require_filled_profile
    unless @profile && @profile.filled?
      flash[:alert] = t 'users.errors.foreign_user_has_no_profile'
      redirect_to root_path
    end
  end
end
