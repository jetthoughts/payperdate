class FoursquareVenuesMap
  constructor: ->
    @infowindow = new google.maps.InfoWindow
    map_center = new google.maps.LatLng(40.743095,-74.006867)
    options =
      center: map_center
      mapTypeId: google.maps.MapTypeId.ROADMAP
      zoom: 15
    @venue_markers = []
    @list = $('#venues_list')
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
    @list.html()

  show_venues: (venues) =>
    i = 0
    list_content = "<table class='table bordered'>"
    while i < venues.length
    # create a closure for your latitude/longitude pair
      ((venue) =>
        list_content += @venue_item_content(venue)
        # set the location...
        latLng = new google.maps.LatLng(venue.location.lat, venue.location.lng)

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
    list_content += '</table>'
    @list.html(list_content)

  venue_item_content: (venue) ->
    """
      <tr>
        <td>
          <b>#{venue.name}</b>
        </td>
        <td>
          Phone: #{venue.contact?.phone},
          Address: #{venue.location?.address}, #{venue.location?.crossStreet}, #{venue.location?.city},
        </td>
        <td>
          <a target='_blank' href='#{venue.menu?.url}'>Menu</a>, <a target='_blank' href='#{venue.url}'>more info</a>
        </td>
        <td>Checkins count: #{venue.stats?.checkinsCount}</td>
      </tr>
    """

  venue_content: (venue) ->
    """
      <div>
        <b>#{venue.name}</b>
        <p>Phone: #{venue.contact?.phone}</p>
        <p>Address: #{venue.location?.address}, #{venue.location?.crossStreet}, #{venue.location?.city}</p>
        <p><a target='_blank' href='#{venue.menu?.url}'>Menu</a></p>
        <p><a target='_blank' href='#{venue.url}'>more info</a></p>
        <p>Checkins count: #{venue.stats?.checkinsCount}</p>
      </div>
    """
$ ->
  if $('#foursquare_venues').length
    new FoursquareVenuesMap




















