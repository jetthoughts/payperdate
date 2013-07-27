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
    setup_current_profile
    setup_search
    setup_profiles
    setup_users
  end

  def setup_current_profile
    @profile = current_user.profile
  end

  def setup_search
    params[:q] ||= {}
    params[:location] ||= @profile.default_search['location']
    params[:max_distance] ||= @profile.default_search['max_distance']
    @q = @profile.near_me(params[:location], params[:max_distance])
    @q = @q.preload(:user).search(params[:q])
  end

  def setup_profiles
    @profiles = @q.result
    @profile_sections = Profile.searchable_params
  end

  def setup_users
    @users = @profiles.map do |profile|
      profile.user.distance = profile['distance'] unless profile.user.nil?
      profile.user
    end
    @users.compact!
  end
end
