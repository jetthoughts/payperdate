$ ->

  $player_wrap = $("#video_player")
  return unless $player_wrap.length
    
  player = $f($player_wrap[0])
  player_ready = ->
    $play_button = $("#layer5") 
    $play_button.click ->
      $play_button.removeClass("force-show").hide()
      player.api('play')
      false
  
  player.addEvent('ready', player_ready)