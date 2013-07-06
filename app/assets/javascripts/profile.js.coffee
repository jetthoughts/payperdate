# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

class ProfileEditorViewModel
  constructor: ->
    @datePreferences =
      acceptedDistance:
        care: ko.observable ($ '#date_preferences_accepted_distance_do_care').val() is 'true'
        doCare: -> @datePreferences.acceptedDistance.care true
        dontCare: -> @datePreferences.acceptedDistance.care false

if railsController == 'profile'
  window.model = new ProfileEditorViewModel
  ko.applyBindings window.model
