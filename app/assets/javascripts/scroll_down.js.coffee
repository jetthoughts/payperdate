scroll_btn = $('.scrolldown_button')

scroll_btn.bind 'click', (event) ->
  event.preventDefault()
  tarId = @.hash
  h = $(tarId).height()
  $('body').animate({scrollTop: h + 300}, 'slow')