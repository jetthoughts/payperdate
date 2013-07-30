$ = jQuery
iframe = $('#video_player')[0]
player = $f(iframe)

$('.play_button').bind 'click', (event) ->
  event.preventDefault()
  $(@).hide()
  player.api('play')