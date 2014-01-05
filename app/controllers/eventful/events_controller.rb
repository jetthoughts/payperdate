class Eventful::EventsController < ApplicationController
  require 'search_eventful_venues_service'

  def index
    res = SearchEventfulVenuesService.new.search_events(params)
    @events = res['events']['event']
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
    @event = SearchEventfulVenuesService.new.get_event(params[:id])
  end

end