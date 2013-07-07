class BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_finish_signup

  helper_method :page_owner?, :selected_user

  private

  def redirect_to_finish_signup
    redirect_to edit_user_registration_path, notice: 'Need to complete registration. Fill your email and password' if current_user.registration_incomplete?
  end

  def selected_user
    params[:user_id].present? ? User.find(params[:user_id]) : current_user
  end

  def page_owner?
    current_user == selected_user
  end

end