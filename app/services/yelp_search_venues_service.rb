class YelpSearchVenuesService
  require 'oauth'
  CONSUMER_KEY = '18K3VT5nKrkL2YHa8PJhKQ'
  CONSUMER_SECRET = 'z-uTlhyW7o39QVQNqQPtmMA5Q_0'
  TOKEN = 'ilr8BB2KdBYLGG8JS7lSfPftlpxLZPpk'
  TOKEN_SECRET = 'ADvN-y4-NFNO_eoaZrj4D93xi_w'
  API_HOST = 'api.yelp.com'

  LIMIT = 20

  def search(city, offset = 0)
    path = "/v2/search?term=restaurants&offset=#{offset}&location=#{CGI.escape(city)}"
    p path
    parse(access_token.get(path).body)
  end

  def store(city, start_offset = 0)
    entries = search(city, start_offset)
    if entries.present?
      store_entries(entries)
      start_offset += LIMIT
      if entries.size == LIMIT && start_offset < 1000
        store(city, start_offset)
      end
    end
  end

  private

  def store_entries(entries)
    entries.each do |hash|
      Venue.create source: 'yelp',
                   name: hash['name'],
                   rating: hash['rating'].to_f,
                   url: hash['url'],
                   external_id: hash['id'],
                   address: hash['location']['display_address'].join(', '),
                   category: 'food',
                   description: hash['snippet_text'],
                   phones: [hash['phone']].compact,
                   pic_url: hash['image_url']
    end
  end

  def parse(res)
    p res
    JSON.parse(res)['businesses']
  end

  def access_token
    @consumer ||= OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {:site => "http://#{API_HOST}"})
    @access_token ||= OAuth::AccessToken.new(@consumer, TOKEN, TOKEN_SECRET)
  end
end