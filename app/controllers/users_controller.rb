class UsersController < BaseController
  before_filter :ensure_user_has_filled_profile
  before_filter :setup_search_params, only: [:index, :search]
  before_filter :setup_profiles_and_users, only: [:index, :search]
  before_filter :setup_target_user, only: [:block, :unblock, :favorite, :remove_favorite]
  after_filter :track_block_activity, only: :block
  after_filter :track_unblock_activity, only: :unblock

  def index
  end

  def search
    render :index
  end

  # FIXME: Why the hell it is GET method ? Shouldn't it be POST or PUT, whatever
  #        but not GET.
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

  def setup_profiles_and_users
    @profile = current_user.profile
    @query = @profile.public_search(@search_query)
    @profiles = @query.result
    @users = @profiles.collect(&:auto_user_with_distance).compact
  end

  def setup_target_user
    @target = User.find params[:id]
  end

  def setup_search_params
    @search_query = current_user.profile.default_search
        .merge(params[:query] || {})
        .merge(params.slice('location', 'max_distance'))
  end

  def track_block_activity
    current_user.track_user_block(@target)
  end

  def track_unblock_activity
    current_user.track_user_unblock(@target)
  end
end
