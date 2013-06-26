class UsersController < BaseController
  layout 'application'

  def show
    @user = current_user
  end
end