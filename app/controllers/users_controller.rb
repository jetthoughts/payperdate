class UsersController < ActionController::Base
  layout 'application'

  def show
    @user = current_user
  end
end