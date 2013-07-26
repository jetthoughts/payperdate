$ ->
  $('a[rel=popover]').popover()
  $('.tooltip').tooltip()
  $('a[rel=tooltip]').tooltip()

  $('#new_search .dropdown-menu').on 'click', (e) ->
    e.stopPropagation()

  collapsSearch = $('#collapse_other_criterias')

  if collapsSearch.length > 0
    collapsSearch.on 'shown', ->
        $(@).addClass('shown')
      .on 'hide', ->
        $(@).removeClass('shown')
