class PhotosController
  FILE_LIMIT:  5 * 1024 * 1024
  FILE_TYPES:  /(\.|\/)(gif|jpe?g|png)$/i
  constructor: (container) ->
    @container = container
    @initGallery()
    @initPhotosUpload()

  initGallery: ->
    $('#photos_container a[rel=gallery]').fancybox()

  initPhotosUpload: ->
    $('#fileupload').fileupload
      dataType: 'html'
      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        $('#progress .bar').css('width', progress + '%')
      add: (e, data, index) ->
        file = data.files[0]
        file_size = file.size
        file_name = file.name
        if file_size > PhotosController::FILE_LIMIT
          alert("Sorry. But file '" + file_name + "' too big. Select smaller files(< 5 Mb), please")
          return
        file_type = file.type
        if !PhotosController::FILE_TYPES.test(file_type)
          alert("Sorry. But file '" + file_name + "' has wrong extension. We need jpg, png or gif please")
          return
        data.submit();
      done: (e, data) =>
        $('#progress .bar').css('width', '0%')
        @container.append(data.result);
        @initGallery()
      fail: (e,data) ->
        console.log(data.messages)
        alert(data.messages || 'Sorry. Upload failed')
    $('#fileupload').on 'fileuploadprocessalways', ->
      alert('sddsf')
$ ->
  container = $('#photos_container').first()
  if container
    new PhotosController(container)