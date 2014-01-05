class SearchEventfulVenuesService

  def initialize
  end

  DEFAULT_CITY = 'New York'
  DEFAULT_DATE = 'Future'
  DEFAULT_KEYWORDS = 'Restaurant'

  def search_events(options)
    page_number = options[:page]
    city = options[:city] || DEFAULT_CITY
    date = options[:date] || DEFAULT_DATE
    keywords = options[:keywords] || DEFAULT_KEYWORDS
    client.get('/events/search', { location: city, keywords: keywords, page_number: page_number , date: date })
  end

  def search_venues(options)
    page_number = options[:page]
    city = options[:city] || DEFAULT_CITY
    date = options[:date]  || DEFAULT_DATE
    keywords = options[:keywords] || DEFAULT_KEYWORDS
    client.get('/venues/search', { location: city, keywords: keywords, page_number: page_number , date: date })
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