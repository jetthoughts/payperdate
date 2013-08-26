class Me::FavoritesController < ApplicationController
  def index
    @users = current_user.favorite_users
  end
end
