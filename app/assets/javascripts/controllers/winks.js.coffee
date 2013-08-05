class WinkFormViewModel
  constructor: ->
    @wink = ko.observable(null)
    @readyToSubmit = ko.computed =>
      @wink() isnt null

class WinksController
  constructor: ->
    @initNewWink()

  initNewWink: ->
    wink_form = $('#new_wink')
    send_wink_btn = $('#send_wink_btn')
    wink_form.on 'ajax:before', (e, response) ->
      $(@).closest('.modal').modal('hide')

    wink_form.on 'ajax:success', (e, response) ->
      if response.success
        FlashPopup.success(response.message)
      else
        FlashPopup.error(response.message)
      send_wink_btn.remove()

    wink_form.on 'ajax:error', (e, response) ->
      FlashPopup.error('Sorry. Something went wrong')




$ ->
  if $('#new_wink').length
    new WinksController()
    vm = new WinkFormViewModel
    ko.applyBindings vm
