class ProfilesController < BaseController
  layout 'application'
  before_filter :load_profile
  before_filter :ensure_user_has_filled_profile
  before_filter :require_filled_profile

  def show
  end

  private

  def load_profile
    @profile = selected_user.profile
    # @profile.safe_for_user = current_user
  end

  def require_filled_profile
    unless @profile.filled?
      flash[:alert] = t 'users.errors.foreign_user_has_no_profile'
      redirect_to root_path
    end
  end
end
