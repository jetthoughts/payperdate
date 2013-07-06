class ProfileController < ApplicationController
  before_filter :setup_user_and_profile

  def edit
  end

  def update
    @profile.update profile_params
    if @profile.valid?
      redirect_to me_path
    else
      render :edit
    end
  end

  private

  def general_info_params
    params.require(:profile).require(:general_info)
      .permit(:address_line_1, :address_line_2, :city, :state, :zip_code,
              :tagline, :description)
  end

  def personal_preferences_params
    params.require(:profile).require(:personal_preferences)
      .permit(:sex, :partners_sex, :relationship, :want_relationship)
  end

  def date_preferences_params
    params.require(:profile).require(:date_preferences)
      .permit(:accepted_distance, :accepted_distance_do_care, :smoker, 
              :drinker, :description)
  end

  def optional_info_params
    params.require(:profile).require(:optional_info)
      .permit(:age, :education, :occupation, :annual_income, :net_worth,
              :height, :body_type, :religion, :ethnicity, :eye_color,
              :hair_color, :address, :children, :smoker, :drinker)
  end

  def profile_params
    {}.merge(general_info: general_info_params)
      .merge(personal_preferences: personal_preferences_params)
      .merge(date_preferences: date_preferences_params)
      .merge(optional_info: optional_info_params)
  end

  def setup_user_and_profile
    @user = current_user
    @profile = @user.profile
  end
end
