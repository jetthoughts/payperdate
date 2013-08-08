class Me::BlocksController < ApplicationController
  def index
    @users = current_user.blocked_users
  end
end
