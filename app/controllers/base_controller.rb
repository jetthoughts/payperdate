class BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_finish_signup

  helper_method :page_owner?, :selected_user, :current_profile

  protected

  def selected_user
    user_from_param.present? ? user_from_param : current_user
  end

  def page_owner?
    current_user == selected_user
  end

  def user_from_param
    User.find(params[user_param_name]) if params[user_param_name].present?
  end

  def user_param_name
    :user_id
  end

  private

  def current_profile
    current_user.profile
  end

  def redirect_to_finish_signup
    redirect_to edit_user_registration_path, notice: 'Need to complete registration. Fill your email and password' if current_user.registration_incomplete?
  end

end