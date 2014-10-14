class FbgImg
  constructor: (@img, @key) ->
    return $ if @img.hasClass 'hasImg'
    @img.addClass 'hasImg'
    @domElem = $('<img>').attr({
      src : fbg.randSrc
      id: "#{@key}:img"
    }).css({
      position: 'absolute'
      width: @img.width()
      height: @img.height()
    }).click (e) ->
      e.stopPropagation()

  addTo : (div) ->
    div.prepend @domElem
  
window.fbg ?= {}
window.fbg.FbgImg = FbgImg