class FbgImg
  constructor: (img, key, url) ->
    img.addClass 'hasGraffiti'
    domElem = $('<img>').attr({
      src : url
    })
    .addClass('img'+key)
    .css({
      position: 'absolute'
      'z-index': 2
      width: img.width()
      height: img.height()
      left: img.css('left') or 0
      top: img.css('top') or 0
    })
    .error (e) ->
      img.removeClass 'hasGraffiti'
      $(@).remove()
      fbg.cache.doesntExist key
    img.parent().prepend domElem

window.fbg ?= {}
window.fbg.FbgImg = FbgImg
