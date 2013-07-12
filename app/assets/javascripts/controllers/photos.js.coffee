class PhotosController
  FILE_LIMIT:  5 * 1024 * 1024
  FILE_TYPES:  /(\.|\/)(gif|jpe?g|png)$/i
  constructor: (container) ->
    @container = container
    @initGallery()
    @initAvatarsUpload()
    @initUseAsAvatar()

  initGallery: ->
    $('#photos_container a[rel=gallery]').fancybox()

  initAvatarsUpload: ->
    new FileUpload '#fileupload', (data) =>
      @container.append(data.result);
      @initGallery()

  initUseAsAvatar: ->
    $('body').on 'ajax:success', '[data-behavior=use-as-avatar]', ()->
      $(@).remove()
$ ->
  if $('#photos_container').length
    new PhotosController($('#photos_container').first())