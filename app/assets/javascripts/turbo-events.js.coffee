@turboEventsReadyList = []

@railsController = $('body').attr('rails-controller')
@railsAction = $('body').attr('rails-action')
@railsFullAction = "#{railsController}##{railsAction}"

@ready = (onready) ->
  @turboEventsReadyList.push onready

document.addEventListener 'page:load', ->
  turboEventsReadyList.forEach (onready) -> 
    onready()
