$ ->
  $.fn.focus_with_highlight = ->
    @each (i, obj) ->
      $this = $(this)
      $($this).animate(
        "background-color": "#ff0000"
      , "fast").animate
        "background-color": "#ffffff"
      , "slow", ->
        $($this).focus()
  $.fn.remove_with_animation = ->
    @each (i, obj) ->
      $(@).hide 'slow', -> $(@).remove()