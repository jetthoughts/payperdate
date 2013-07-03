class BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_finish_signup

  private

  def redirect_to_finish_signup
    redirect_to edit_user_registration_path, notice: 'Need to complete registration. Fill your email and password' if current_user.registration_incomplete?
  end

end