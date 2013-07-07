class AvatarsController
  constructor: (container) ->
    @initAvatarsUpload()

  initAvatarsUpload: ->
    new FileUpload '#fileupload', (data) =>
      $('#avatar').replaceWith(data.result)

$ ->
  if $('#avatar').length
    new AvatarsController()