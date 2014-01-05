class Eventful::VenuesController < ApplicationController
  require 'search_eventful_venues_service'

  def index
    res = SearchEventfulVenuesService.new.search_venues(params)
    @venues = res['venues']['venue']
    page  = res['page_number'].to_i
    page_count = res['page_count'].to_i
    if page > 1
      @prev_page = page - 1
    end

    if page < page_count - 1
      @next_page = page + 1
    end
  end

  def show
    @venue = SearchEventfulVenuesService.new.get_venue(params[:id])
  end

end