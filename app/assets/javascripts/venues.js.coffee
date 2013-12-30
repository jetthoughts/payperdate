class VenuesMap
  constructor: ->

    map_center = new google.maps.LatLng(40.743095,-74.006867)
    options =
      center: map_center
      mapTypeId: google.maps.MapTypeId.ROADMAP
      zoom: 8
    @venue_markers = []
    @map = new google.maps.Map(document.getElementById("map"), options)
    # and additional coordinates, just add a new item
    marker = new google.maps.Marker(
      icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png'
      position: map_center
      map: @map,
      title: "You here"
      draggable: true
      animation: google.maps.Animation.DROP
    )
    google.maps.event.addListener marker, 'dragend', =>
      pos = marker.getPosition()
      @load_venues(pos)
    @load_venues(map_center)

  load_venues: (point) =>
    ll = @point_to_ll(point)
    @clear_venues()
    $.ajax
      method: 'GET'
      url: '/venues/search.json'
      type: 'JSON'
      success: @show_venues
      data:
        ll: ll
  point_to_ll: (pos)->
    "#{pos.lat()},#{pos.lng()}"

  clear_venues: =>
    marker.setMap(null) for marker in @venue_markers
    @venue_markers = []

  show_venues: (venues) =>
    i = 0

    while i < venues.length

      # create a closure for your latitude/longitude pair
      ((venue) =>

        # set the location...
        latLng = new google.maps.LatLng(venue.location.lat, venue.location.lng)

        # ...and add the Marker to your map
        marker = new google.maps.Marker(
          position: latLng
          map: @map,
          title: venue.name

        )
        @venue_markers.push(marker)
      ) venues[i]
      i++
$ ->
  new VenuesMap