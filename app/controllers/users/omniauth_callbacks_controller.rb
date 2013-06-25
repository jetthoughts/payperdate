class Users::OmniauthCallbacksController < ApplicationController

  def failure
    process_failure
  end

  def facebook
    process_oauth_login
  end

  def twitter
    process_oauth_login
  end

  private

  def process_oauth_login
    user = User.find_from_oauth request.env["omniauth.auth"]
    if user.persisted?
      flash[:notice] = t "devise.omniauth_callbacks.success", kind: request.env["omniauth.auth"].provider
      sign_in_and_redirect user, event: :authentication
    else
      process_failure
    end
  end

  def process_failure
    flash[:alert] = t "devise.omniauth_callbacks.failure"
    redirect_to root_path
  end

end
