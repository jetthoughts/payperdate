class @FileUpload
  FILE_LIMIT:  5 * 1024 * 1024
  FILE_TYPES:  /(\.|\/)(gif|jpe?g|png)$/i

  constructor: (input, onDone) ->
    @input = input
    @onDone = onDone
    @initAvatarsUpload()

  initAvatarsUpload: ->
    $(@input).fileupload
      dataType: 'html'
      progressall: (e, data) =>
        progress = parseInt(data.loaded / data.total * 100, 10)
        @setProgress(progress)
      add: (e, data, index) ->
        file = data.files[0]
        file_size = file.size
        file_name = file.name
        if file_size > FileUpload::FILE_LIMIT
          alert("Sorry. But file '" + file_name + "' too big. Select smaller files(< 5 Mb), please")
          return
        file_type = file.type
        if !FileUpload::FILE_TYPES.test(file_type)
          alert("Sorry. But file '" + file_name + "' has wrong extension. We need jpg, png or gif please")
          return
        data.submit();
      done: (e, data) =>
        @setProgress(0)
        @onDone(data)
      fail: (e,data) =>
        @setProgress(0)
        alert(data.messages || 'Sorry. Upload failed')

  setProgress: (val) ->
    $('#progress .bar').css('width', val + '%')