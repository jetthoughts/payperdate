class UsersController < BaseController
  before_filter :ensure_user_has_filled_profile

  def index
    @users = User.all
  end
end
