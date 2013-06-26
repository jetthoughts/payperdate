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
      flash[:notice] = t "devise.omniauth_callbacks.success", kind: provider
      sign_in_and_redirect user, event: :authentication
    else
      process_failure
    end
  end

  def process_failure
    flash[:alert] = t "devise.omniauth_callbacks.failure", kind: provider
    redirect_to root_path
  end

  def provider
    request.env["omniauth.strategy"].name
  end

end
