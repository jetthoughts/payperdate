class BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_finish_signup
  before_action :update_online

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

  def state_of_model(model)
    { success: !model.errors.any?,
      message: if model.errors.any?
                 model.errors.full_messages.first
               else
                 t "#{model.class.name.demodulize.downcase.pluralize}.messages.was_sent"
               end
    }
  end

  private

  def current_profile
    current_user.profile
  end

  def redirect_to_finish_signup
    if current_user.registration_incomplete?
      redirect_to edit_user_registration_path,
                  notice: 'Need to complete registration. Fill your email and password'
    end
  end

  def self.default_profile_activity_tracking(*args)
    after_filter :default_tracks_profile_activity, *args
  end

  def default_tracks_profile_activity
    current_user.activities.create! action: "#{action_name}_#{controller_name.singularize}",
                                    subject: current_profile
  end

  def update_online
    current_user.touch(:last_request_at) if user_signed_in?
  end

end
