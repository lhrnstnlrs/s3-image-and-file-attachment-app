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

  $('#image-uploader').bind "ajax:complete", (e, data, xhr) ->
    $("#image-list").append "<img src=" + data.find('Location') + " class='thumb' />"
    $('form #post-attachments').append "<input type='hidden' name='images[]' value='"+ data.responseJSON.id + "' />"
		$('#uploads_container').html ''

	$('#image-uploader input:file').change (evt) ->
    parentEl = $(this).parent()
    tgt = evt.target or window.event.srcElement
    files = tgt.files
    if FileReader and files and files.length
      fr = new FileReader
      extension = files[0].name.split('.').pop().toLowerCase()

      fr.onload = (e) ->
        success = fileTypes.indexOf(extension) > -1
        if success
          $('#uploads_container').append '<img src="' + fr.result + '" class="thumb"/>'
        return

      fr.readAsDataURL files[0]
    return
