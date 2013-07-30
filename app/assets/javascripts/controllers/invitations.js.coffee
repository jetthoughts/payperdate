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

    invitation_form.on 'ajax:before', (e, response) ->
      $(@).closest('.modal').modal('hide')

    invitation_form.on 'ajax:success', (e, response) ->
      if response.success
        FlashPopup.success(response.message)
      else
        FlashPopup.error(response.message)
      $('#invite_user_btn').remove()

    invitation_form.on 'ajax:error', (e, response) ->
      FlashPopup.error('Sorry. Something went wrong')

  removeInvitation: (obj)->
    invitation = $(obj).closest('.invitation')
    invitation.remove_with_animation()

$ ->
  new InvitationController()
