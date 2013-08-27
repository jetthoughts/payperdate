class Me::ViewersController < ApplicationController

  def index
    @views = current_user.back_profile_views
  end

end
