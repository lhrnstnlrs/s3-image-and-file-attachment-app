jQuery(document).on 'turbolinks:load', ->
  fileTypes = ['jpg', 'jpeg', 'png', 'gif']

  $("#image-uploader").S3Uploader
    progress_bar_target: $('#uploads_container')
    remove_failed_progress_bar: false
    before_add: (file) ->
      extension = file.type.split('/')[1]
      if !(fileTypes.indexOf(extension))
        alert 'File not supported!'
        false
      else if (file.size > 5000000)
        alert 'File size too large!'
        false
      else
        true

  $("#image-uploader").bind 's3_upload_failed', (e, content) ->
    alert content.filename + ' failed to upload'