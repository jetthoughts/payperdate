class ProfilesController < BaseController
  layout 'application'
  before_filter :load_profile
  before_filter :ensure_user_has_filled_profile
  before_filter :require_filled_profile
  before_filter :check_if_user_is_blocked

  def show
  end

  private

  def load_profile
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @profile.safe_for_user = current_user
  end

  def check_if_user_is_blocked
    if @profile.user.blocked?
      flash[:alert] = t 'users.errors.user_blocked'
      redirect_to root_path
    end
  end

  def require_filled_profile
    unless @profile.filled?
      flash[:alert] = t 'users.errors.foreign_user_has_no_profile'
      redirect_to root_path
    end
  end
end
