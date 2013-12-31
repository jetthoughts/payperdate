class VenuesController < ApplicationController
  require 'search_venues_service'

  def index

  end

  def yelp

  end

  def list
    @venues = Venue.page(params[:page] || 1)
  end

  def search
    if params['yelp']
      render json: Venue.geocoded
    else
      options = { ll: params[:ll], city: 'New York' }
      render json: SearchVenuesService.new.search(options)
    end
  end
end