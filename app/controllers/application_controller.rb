class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  respond_to :html, :js

  #before_filter :configure_permitted_parameters, if: :devise_controller?
  #
  #protected
  #
  #def configure_permitted_parameters
  #  devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  #end

  protected

  def ensure_user_has_filled_profile
    unless current_user && current_user.profile.filled?
      flash[:alert] = t 'users.errors.current_user_has_no_profile'
      redirect_to edit_profile_path
    end
  end
end
