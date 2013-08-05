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
  win = window
  if !$('#layer1')
    null
  layer1 = $('#layer1')
  layer2 = $('#layer2')
  layer3 = $('#layer3')
  layer4 = $('#layer4')
  layer5 = $('#layer5')
  layer6 = $('#layer6')
  content = $('.container').eq(0)
  footer = layer6
  signupForm = layer2
  signupFormWidth = signupForm.width()
  doc = $(document)
  bodyHeight = $('body').height()
  ticking = false
  lastScrollY = 0

#  layer2.css("position","fixed");

  offParallax = ->
    prefix(layer1, "transform", "translate3d(0px, 0px, 0px)")
#    prefix(layer2, "transform", "translate3d(0px, 0px, 0px)")
    prefix(layer3, "transform", "translate3d(0px, 0px, 0px)")
    prefix(layer4, "transform", "translate3d(0px, 0px, 0px)")
    prefix(layer5, "transform", "translate3d(0px, 0px, 0px)")
    prefix(layer6, "transform", "translate3d(0px, 0px, 0px)")

  signupFormRight = ->
    contentWidth = content.width()
    windowWidth = $(window).width()
    toRigth = (parseInt(windowWidth) - parseInt(contentWidth))/2
    signupForm.css("right",Math.ceil(toRigth) + "px")

  signupBottomStop = ->
    footerHeight = footer.height()
    winHeight = $(win).height()
    docScroll = doc.scrollTop()
    docHeight = doc.height()
    diff = parseInt(docHeight)  - parseInt(footerHeight)
    stopPoint = diff - parseInt(winHeight)
    console.log($(document).scrollTop())
    console.info("point " + stopPoint)
    if (docScroll >= stopPoint)
      signupForm.css({
        "position":"absolute",
        "top":stopPoint + "px",
        "right":0
      })

    else
      signupForm.css({
        "position":"fixed",
        "top": "80px"
      })
      signupFormRight()

  initParallax = ->
    w = @.innerWidth
    if (w < 767)
      win.removeEventListener('scroll', onScroll, false)
      offParallax()
    else
      updateElements(win.scrollY)
      win.addEventListener('scroll', onScroll, false)


  onScroll = (evt) ->
    if !ticking
      ticking = true
      requestAnimFrame(updateElements)
      lastScrollY = win.scrollY
    signupBottomStop()

  updateElements = ->
    relativeY = lastScrollY / 3000
    prefix(layer1, "transform", "translate3d(0px," + pos(0, -740, relativeY, 0) + 'px, 0)')
#    prefix(layer2, "transform", "translate3d(0px," + pos(0, 3000, relativeY, 0) + 'px, 0)')
    prefix(layer3, "transform", "translate3d(0px," + pos(200, -2800, relativeY, 0) + 'px, 0)')
    prefix(layer4, "transform", "translate3d(0px," + pos(-300, 500, relativeY, 0) + 'px, 0)')
    prefix(layer5, "transform", "translate3d(0px," + pos(0, 100, relativeY, 0) + 'px, 0)')
    prefix(layer6, "transform", "translate3d(0px," + pos(-600, 1300, relativeY, 0) + 'px, 0)')
    ticking = false

  pos = (base, range, relY, offset) ->
    Math.ceil(base + limit(0, 1, relY - offset) * range)

  prefix = ($element, prop, value) ->
    prefs = ['webkit', 'moz',  'ms']
    for pref in prefs
      key = '-' + pref + '-' + prop
      $element.css(key, value)

  limit = (min, max, value) ->
    Math.max(min, Math.min(max, value))

  updateElements(win.scrollY)

  layer1.addClass('force-show')
#  layer2.addClass('force-show')
  layer3.addClass('force-show')
  layer4.addClass('force-show')
  layer5.addClass('force-show')
  layer6.addClass('force-show')

  win.addEventListener('resize', initParallax, false)
  win.addEventListener('resize', signupFormRight, false)
  initParallax()
  signupFormRight()

  true
