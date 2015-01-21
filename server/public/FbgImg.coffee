class FbgImg
  constructor: (img, key, url) ->
    img.addClass 'hasGraffiti'
    css =
      position: 'absolute'
      'z-index': 3
      width: img.outerWidth()
      # height: img.outerHeight()
    img.parent().css({'overflow':'hidden'})
    css.left = img.css('left') if img.css('left') != '0px'
    css.top = img.css('top') if img.css('top') != '0px'
    css.marginLeft = img.css('marginLeft') if img.css('marginLeft') != '0px'
    css.marginTop = img.css('marginTop') if img.css('marginTop') != '0px'

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