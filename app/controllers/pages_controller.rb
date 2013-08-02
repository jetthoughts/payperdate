class PagesController < ApplicationController
  def about
  end
  def landing
    @latest_users = User.active.reverse_order.limit(15)
    render layout: 'landing'
  end
end
