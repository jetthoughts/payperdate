window.turboEventsReadyList = []

window.railsController = ($ '#turbo_events_controller').text()

window.ready = (onready) ->
  window.turboEventsReadyList.unshift onready

document.addEventListener 'page:load', ->
  turboEventsReadyList.forEach (onready) -> 
    onready()
