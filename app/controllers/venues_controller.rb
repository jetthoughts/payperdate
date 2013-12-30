class VenuesController < ApplicationController
  require 'search_venues_service'
  def index

  end

  def search
    options = {ll: params[:ll], city: 'New York'}
    render json: SearchVenuesService.new.search(options)
  end
end