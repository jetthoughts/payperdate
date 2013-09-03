class ConversationController
  constructor: ->
    @initRemoveMessage()
    @initCreateMessage()

  initRemoveMessage: ->
    $('.messages').on 'ajax:success', 'a[data-remote=true]', (e) =>
      @removeMessage(e.target)

    $('.messages').on 'ajax:error', 'a[data-remote=true]', ->
      FlashPopup.error('Sorry. Something went wrong')

  initCreateMessage: ->
    message_form = $('#new_message')

    message_form.on 'ajax:success', (e, response) ->
      if response.length > 0
        $(".messages").append(response)
        $("#message_content").val("")

    message_form.on 'ajax:error', (e, response) ->
      FlashPopup.error('Sorry. Something went wrong')

  removeMessage: (obj)->
    message = $(obj).closest('.message')
    message.remove_with_animation()

$ ->
  new ConversationController()
