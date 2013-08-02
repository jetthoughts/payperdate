$ ->
  $('#new_profile_note').on 'ajax:success', (event, response, status) ->
    $('#profile_notes').append(response)
    $('#profile_note_text').val('')

$ ->
  $('.profile-inline-edit-activate').click ->
    $('.profile-inline-edit').toggleClass('profile-hide')
    false
