class UsersController < BaseController
  before_filter :ensure_user_has_filled_profile
  before_filter :setup_profiles_and_users
  before_filter :setup_target_user, only: [:block, :unblock, :favorite, :remove_favorite]
  after_filter :track_block_activity, only: :block
  after_filter :track_unblock_activity, only: :unblock

  def index
  end

  def search
    render :index
  end

  def unsubscribe
    user = User.where(email: params[:md_email]).first
    user.unsubscribe!

    redirect_to root_path, notice: t("unsubscribed")
  end

  def favorite
    current_user.favorite_user @target
    flash[:notice] = I18n.t('flash.users.favorite.notice')
    redirect_to user_profile_path @target
  end

  def remove_favorite
    current_user.remove_favorite_user @target
    flash[:notice] = I18n.t('flash.users.remove_favorite.notice')
    redirect_to user_profile_path @target
  end

  def block
    current_user.block_user @target
    flash[:notice] = I18n.t('flash.users.block.notice')
    redirect_to user_profile_path @target
  end

  def unblock
    current_user.unblock_user @target
    flash[:notice] = I18n.t('flash.users.unblock.notice')
    redirect_to user_profile_path @target
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
    #FIXME: do not change params
    params[:q] ||= {}
    params[:location] ||= @profile.default_search['location']
    params[:max_distance] ||= @profile.default_search['max_distance']

    #FIXME: Rename `q` to more readable
    query = params[:q].clone
    @q = @profile.near_me(params[:location], params[:max_distance]).not_mine(@profile)
        .preload(:user).published_and_active
        .multiselect_search(query.slice(*Profile.multiselect_params))
        .search(query.slice!(*Profile.multiselect_params))
  end

  def setup_profiles
    @profiles = @q.result
    #FIXME: Convert to helper, too many shared instances
    @profile_sections = Profile.searchable_params
  end

  def setup_users
    @users = @profiles.map do |profile|
      profile.auto_user.distance = profile['distance'] unless profile.auto_user.nil?
      profile.auto_user
    end
    @users.compact!
  end

  def setup_target_user
    @target = User.find params[:id]
  end

  def track_block_activity
    current_user.track_user_block(@target)
  end

  def track_unblock_activity
    current_user.track_user_unblock(@target)
  end
end
