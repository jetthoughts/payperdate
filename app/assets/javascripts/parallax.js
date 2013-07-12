// shim layer with setTimeout fallback
window.requestAnimFrame = (function () {
  return  window.requestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.oRequestAnimationFrame ||
    window.msRequestAnimationFrame ||
    function (callback) {
      window.setTimeout(callback, 1000 / 60);
    };
})();

(function (win, d) {



  var $ = d.querySelector.bind(d);

  if(!$('#layer1')){
    return null
  }

  var layer1 = $('#layer1');
  var layer2 = $('#layer2');
  var layer3 = $('#layer3');
  var layer4 = $('#layer4');
  var layer5 = $('#layer5');
  var layer6 = $('#layer6');


  var ticking = false;
  var lastScrollY = 0;

  function onResize() {
    updateElements(win.scrollY);
  }

  function onScroll(evt) {

    if (!ticking) {
      ticking = true;
      requestAnimFrame(updateElements);
      lastScrollY = win.scrollY;
    }
  }

  function updateElements() {

    var relativeY = lastScrollY / 3000;

    prefix(layer1.style, "Transform", "translate3d(0px," +
      pos(0, 100, relativeY, 0) + 'px, 0)');

    prefix(layer2.style, "Transform", "translate3d(0px," +
      pos(0, 1900, relativeY, 0) + 'px, 0)');

    prefix(layer3.style, "Transform", "translate3d(0px," +
      pos(-100, -1000, relativeY, 0) + 'px, 0)');

    prefix(layer4.style, "Transform", "translate3d(0px," +
      pos(-500, 300, relativeY, 0) + 'px, 0)');

    prefix(layer5.style, "Transform", "translate3d(0px," +
      pos(100, -600, relativeY, 0) + 'px, 0)');

    prefix(layer6.style, "Transform", "translate3d(0px," +
      pos(0, -1000, relativeY, 0) + 'px, 0)');
    layer6.style.marginBottom = pos(0, -1000, relativeY, 0) + "px";


    ticking = false;

  }

  function pos(base, range, relY, offset) {
    return base + limit(0, 1, relY - offset) * range;
  }

  function prefix(obj, prop, value) {
    var prefs = ['webkit', 'Moz', 'o', 'ms'];
    for (var pref in prefs) {
      obj[prefs[pref] + prop] = value;
    }
  }

  function limit(min, max, value) {
    return Math.max(min, Math.min(max, value));
  }

  updateElements(win.scrollY);

  layer1.classList.add('force-show');
  layer2.classList.add('force-show');
  layer3.classList.add('force-show');
  layer4.classList.add('force-show');
  layer5.classList.add('force-show');
  layer6.classList.add('force-show');

  win.addEventListener('resize', onResize, false);
  win.addEventListener('scroll', onScroll, false);


})(window, document);