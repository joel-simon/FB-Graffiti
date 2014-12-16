class FbgImg
  constructor: (img, key, url) ->
    img.addClass 'hasGraffiti'
    css =
      position: 'absolute'
      'z-index': 3
      width: img.outerWidth()
      height: img.outerHeight()

    css.left = img.css('marginLeft') if img.css('marginLeft') != '0px'
    css.top = img.css('marginTop') if img.css('marginTop') != '0px'

    domElem = $('<img>').attr { src: url }
    .addClass 'img'+key
    .css( css )
    .error (e) ->
      img.removeClass 'hasGraffiti'
      $(@).remove()
      fbg.cache.doesntExist key
    img.parent().prepend domElem

window.fbg ?= {}
window.fbg.FbgImg = FbgImg