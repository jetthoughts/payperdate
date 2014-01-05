class SearchEventfulVenuesService

  def initialize
  end

  DEFAULT_CITY = 'New York'
  DEFAULT_DATE = 'Future'

  def search_events(options)
    city = options[:city] || DEFAULT_CITY
    page_number = options[:page]
    date = options[:date] || DEFAULT_DATE
    client.get('/events/search', { location: city, keywords: 'Restaurant', page_number: page_number , date: date })
  end

  def search_venues(options)
    city = options[:city] || DEFAULT_CITY
    page_number = options[:page]
    date = options[:date]  || DEFAULT_DATE
    client.get('/venues/search', { location: city, keywords: 'Restaurant', page_number: page_number , date: date })
  end

  def get_event(id)
    client.get('/events/get', {id: id})
  end

  def get_venue(id)
    client.get('/venues/get', {id: id})
  end

  private

  def client
    @@client ||=  client = EventfulApi::Client.new({})
  end

end