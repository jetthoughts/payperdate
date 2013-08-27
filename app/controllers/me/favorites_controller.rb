class Me::FavoritesController < ApplicationController
  def index
    @users = current_user.favorite_users
  end

  def back
    @users = current_user.back_favorite_users
  end
end
