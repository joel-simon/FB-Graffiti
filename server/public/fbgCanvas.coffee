class FbgCanvas
  constructor : (@img, @key) ->
    @img.addClass 'hasCanvas'
    @stage = $('.stage').first()
    top = "#{(@stage.height() - @img.height())//2}px"
    left = "#{(@stage.width() - @img.width())//2}px"
    width = @img.width()
    height = @img.height()

    @canvas = $('<canvas>')
      .attr({ id: "#{@key}:canvas", width, height })
      .css({
        position: 'absolute'
        top : top
        left : left
        border : "3px ridge #3b579d"
      }).click (e) ->
        e.stopPropagation()

    @fbgImage = $('<img>')
      .attr({
        src : fbg.randSrc
        id: "#{@key}:img"
      }).css({ position: 'absolute', width, height, top, left })
        .click (e) ->
          e.stopPropagation()

  addTo : (div) ->
    div.prepend @fbgImage
    div.prepend @canvas

  remove : () ->
    @canvas.remove()
    @fbgImage.remove()
    @img.removeClass 'hasCanvas'
    delete fbg.canvas

window.fbg ?= {}
window.fbg.FbgCanvas = FbgCanvas