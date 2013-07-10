class UsersController < BaseController
  layout 'application'

  def show
    @user = selected_user
    ensure_user_has_filled_profile
  end

  def index
    @users = User.all
  end

  private

  def user_param_name
    :id
  end

  def ensure_user_has_filled_profile
    unless @user.profile.filled?
      if @user == current_user
        flash[:alert] = t 'users.errors.current_user_has_no_profile'
        redirect_to profile_edit_path
      else
        flash[:alert] = t 'users.errors.foreign_user_has_no_profile'
      end
    end
  end
end
