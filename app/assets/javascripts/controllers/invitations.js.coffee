class InvitationController
  constructor: ->
    @initNewInvitation()
    @initControlLinks()
    @initConterForm()
    @initRejectForm()

  initRejectForm: ->
    $('#invitations').on 'ajax:complete', '.invitation form.reject_form', (e, response) =>
        target = e.target
        $(target).closest('.modal').modal('hide')
        @removeInvitation(target)

    $('#invitations').on 'ajax:error', '.invitation form.reject_form', (e)->
      $(@).closest('.modal').modal('hide')
      FlashPopup.error('Sorry. Something went wrong')

  initConterForm: ->
    $('#invitations').on 'ajax:complete', '.invitation form.edit_invitation', (e, response) =>
      target = e.target
      $(target).closest('.modal').modal('hide')
      @removeInvitation(target)

    $('#invitations').on 'ajax:error', '.invitation form.edit_invitation', (e)->
      $(@).closest('.modal').modal('hide')
      FlashPopup.error('Sorry. Something went wrong')

  initControlLinks: ->
    $('#invitations').on 'ajax:success', '.invitation a[data-remote=true]', (e) =>
      @removeInvitation(e.target)

    $('#invitations').on 'ajax:error', '.invitation a[data-remote=true]', ->
      FlashPopup.error('Sorry. Something went wrong')

  initNewInvitation: ->
    invitation_form = $('#new_invitation')

    invitation_form.on 'ajax:success', (e, response) ->
      if response.success
        $(@).closest('.modal').modal('hide')
        $('#invite_user_btn').remove()
        FlashPopup.success(response.message)
      else
        $('#invitation_errors').html("<div class='alert alert-error'>" +
          "<button type='button' class='close' data-dismiss='alert'>&times;</button>" +
          "<strong>#{response.message}</strong></div>")

    invitation_form.on 'ajax:error', (e, response) ->
      $(@).closest('.modal').modal('hide')
      FlashPopup.error('Sorry. Something went wrong')

  removeInvitation: (obj)->
    invitation = $(obj).closest('.invitation')
    invitation.remove_with_animation()

$ ->
  new InvitationController()
