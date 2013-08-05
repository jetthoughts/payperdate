$ ->
  if $('#video_player').length
    iframe = $('#video_player')[0]
    player = $f(iframe)

    $('.play_button').on 'click', (event) ->
      event.preventDefault()
      $(@).hide()
      player.api('play')