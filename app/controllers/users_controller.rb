class UsersController < BaseController
  before_filter :ensure_user_has_filled_profile
  before_filter :setup_profiles_and_users

  def index
  end

  def search
    render :index
  end

  private

    def user_param_name
      :id
    end

    def setup_profiles_and_users
      @search = params[:search] || {}
      @profiles = Profile.preload(:user).search_hstore(@search)
      @users = @profiles.map { |profile| profile.user }
      @users = @users.select { |user| not user.nil? }
      @profile_sections = Profile.searchable_params
    end
end
