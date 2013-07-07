class UsersController < BaseController
  layout 'application'

  def show
    @user = foreign_user || current_user
    ensure_user_has_filled_profile
  end

  private

  def foreign_user
    User.find params[:id] if params[:id]
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
