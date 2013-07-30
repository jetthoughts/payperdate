class @FlashPopup
  @empty = =>
    $('.flash_messages').empty()
  @error = (msg) =>
    @show('alert-error', msg)
  @success = (msg) =>
    @show('alert-success', msg)
  @show = (cls, msg) =>
    scrollTo($('#flash_messages').append("<div class='alert " + cls + "'>" +
    "<button type='button' class='close' data-dismiss='alert'>&times;</button>" +
    "<strong>" + msg + "</strong>" +
    "</div>"))

