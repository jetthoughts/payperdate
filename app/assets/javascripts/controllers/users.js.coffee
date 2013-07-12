
class SearchViewModel
  constructor: (searchCriterias, selectConfig) ->
    @criterias = ko.observableArray searchCriterias
    @select = {}
    for key, value of selectConfig
      if key isnt 'empty'
        @select[key] = value['items'].map (x) ->
          for key, value of x
            return key: key, title: value



# if railsFullAction in ['users#index', 'users#search']
#   @model = new SearchViewModel @searchCriterias, @selectConfig
#   ko.applyBindings @model


