class SearchVenuesService
  FOOD_CATEGORY_ID = '4d4b7105d754a06374d81259'

  def initialize
  end

  def search(options)
    ll = options[:ll]
    city = options[:city]
    radius = options[:radius] || 1000
    return if ll.nil? && city.nil?
    params = {categoryId: FOOD_CATEGORY_ID}
    if ll.present?
      params[:ll] = ll
    else
      params[:near] = city
    end
    if radius
      params[:radius] = radius
    end
    res = client.search_venues(params)
    parse(res)
  end

  private

  def parse(res)
    res.values[0][0]['items']
  end

  def client
    @@client ||=  Foursquare2::Client.new(client_id: Settings.foursquare.client_id,
                                          client_secret: Settings.foursquare.client_secret)
  end

end