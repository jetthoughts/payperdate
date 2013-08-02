Array::max =->
  Math.max.apply(null, this)

Array::min =->
  Math.min.apply(null, this)

class CustomSpinnerModel
  MAX_AGE: 99
  MIN_AGE: 16
  constructor: (age)->
    @age = ko.observable(age)

  decrease: ->
    cur_val = parseInt(@age())
    @age(@normalize(cur_val - 1))

  increase: ->
    cur_val = parseInt(@age())
    @age(@normalize(cur_val + 1))

  normalize: (val) ->
    [[@MAX_AGE, val].min(), @MIN_AGE].max()

class LandingPageModel
  constructor: ->
    @min_age = new CustomSpinnerModel(22)
    @max_age = new CustomSpinnerModel(25)

ko.applyBindings new LandingPageModel
