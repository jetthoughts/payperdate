window.requestAnimFrame = (->
  return  window.requestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.oRequestAnimationFrame ||
    window.msRequestAnimationFrame ||
    (callback) ->
      window.setTimeout(callback, 1000 / 60)
)()

$ ->
#  $ = querySelector.bind(d)
  win = window
  if !$('#layer1')
    alert 'ffff'
    null
  layer1 = $('#layer1')
  layer2 = $('#layer2')
  layer3 = $('#layer3')
  layer4 = $('#layer4')
  layer5 = $('#layer5')
  layer6 = $('#layer6')
  ticking = false
  lastScrollY = 0

  onResize = ->
    updateElements(win.scrollY)

  onScroll = (evt) ->
    if !ticking
      ticking = true
      requestAnimFrame(updateElements)
      lastScrollY = win.scrollY

  updateElements = ->
    relativeY = lastScrollY / 3000
    prefix(layer1, "transform", "translate3d(0px," + pos(0, 100, relativeY, 0) + 'px, 0)')
    prefix(layer2, "transform", "translate3d(0px," + pos(0, 2600, relativeY, 0) + 'px, 0)')
    prefix(layer3, "transform", "translate3d(0px," + pos(-200, -1300, relativeY, 0) + 'px, 0)')
    prefix(layer4, "transform", "translate3d(0px," + pos(-500, 300, relativeY, 0) + 'px, 0)')
    prefix(layer5, "transform", "translate3d(0px," + pos(100, -100, relativeY, 0) + 'px, 0)')
    prefix(layer6, "transform", "translate3d(0px," + pos(400, -1400, relativeY, 0) + 'px, 0)')
    layer6.css("margin-bottom", pos(0, -1000, relativeY, 0) + "px")
#    layer6.css("margin-bottom", "-1200px")
    ticking = false

  pos = (base, range, relY, offset) ->
    base + limit(0, 1, relY - offset) * range

  prefix = (obj, prop, value) ->
    prefs = ['webkit', 'moz', 'o', 'ms']
    obj.css('-' + pref + '-' + prop, value) for pref in prefs

  limit = (min, max, value) ->
    Math.max(min, Math.min(max, value))

  updateElements(win.scrollY)

  layer1.addClass('force-show')
  layer2.addClass('force-show')
  layer3.addClass('force-show')
  layer4.addClass('force-show')
  layer5.addClass('force-show')
  layer6.addClass('force-show')

  win.addEventListener('resize', onResize, false)
  win.addEventListener('scroll', onScroll, false)
  true
