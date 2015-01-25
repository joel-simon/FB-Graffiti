class FbgImg
  constructor: (img, key, url) ->
    img.addClass 'hasGraffiti'
    css =
      position: 'absolute'
      'z-index': 3
      
      # height: img.outerHeight()
    img.parent().css({'overflow':'hidden'})
    css.left = img.css('left')# if img.css('left') != '0px'
    css.top = img.css('top') if img.css('top') != '0px'
    css.marginLeft = img.css('marginLeft') if img.css('marginLeft') != '0px'
    css.marginTop = img.css('marginTop') if img.css('marginTop') != '0px'

    domElem = $('<img>')
      .addClass 'img'+key
      .css css
      .load (e) ->
        img.parent().prepend $(@)
        if img.hasClass 'profilePic'
          if $(@).css('height') > $(@).css('width')
            $(@).css('width', img.outerWidth())
          else
            $(@).css('height', img.outerHeight())
            $(@).css('left', (img.outerWidth() - $(@).width())/2 )
        else
          $(@).css('width', img.outerWidth())
      .error (e) ->
        img.removeClass 'hasGraffiti'
        fbg.cache.doesntExist key
      .attr { src: url }

    

window.fbg ?= {}
window.fbg.FbgImg = FbgImg