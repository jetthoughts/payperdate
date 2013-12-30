class YelpVenuesMap
  constructor: ->
    @infowindow = new google.maps.InfoWindow
    map_center = new google.maps.LatLng(40.743095,-74.006867)
    options =
      center: map_center
      mapTypeId: google.maps.MapTypeId.ROADMAP
      zoom: 13
    @venue_markers = []
    @map = new google.maps.Map(document.getElementById("map"), options)

    @load_venues()

  load_venues: () =>
    @clear_venues()
    $.ajax
      method: 'GET'
      url: '/venues/search.json'
      type: 'JSON'
      success: @show_venues
      data:
        yelp: true

  clear_venues: =>
    marker.setMap(null) for marker in @venue_markers
    @venue_markers = []

  show_venues: (venues) =>
    i = 0

    while i < venues.length

      # create a closure for your latitude/longitude pair
      ((venue) =>

        # set the location...
        latLng = new google.maps.LatLng(venue.location[0], venue.location[1])

        # ...and add the Marker to your map
        marker = new google.maps.Marker
          position: latLng
          map: @map,
          title: venue.name

        google.maps.event.addListener marker, 'click', =>
          @infowindow.setContent(@venue_content(venue))
          @infowindow.open(@map, marker)

        @venue_markers.push(marker)
      ) venues[i]
      i++

  venue_content: (venue) ->
    """
      <div>
        <img src='#{venue.pic_url}'/>
        <b>#{venue.name}</b>
        <p>Rating: #{venue.rating}</p>
        <p>Phone: #{venue.phones[0]}</p>
        <p>Address: #{venue.address}</p>
        <p>#{venue.description}</p>
        <p><a target='_blank' href='#{venue.url}'>more info</a></p>
      </div>
    """

$ ->
  if $('#yelp_venues').length
    new YelpVenuesMap