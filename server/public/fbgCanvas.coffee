class Canvas
  constructor : (@img, @key) ->
    # window.fbg.get.photoUi().remove()
    @stage = $('.stage').first()
    $('#snowLiftStageActions').remove()
    @canvas = $('<canvas>').attr({
      id: @key
      width: @img.width()
      height: @img.height()
    }).css({
      position: 'absolute'
      top: "#{(@stage.height() - @img.height())//2}px"
      left: "#{(@stage.width() - @img.width())//2}px"
      border : "3px ridge #3b579d"
      zIndex: 1337
    }).click((e) ->
      e.stopPropagation()
    )

  addTo : (div) ->
    div.prepend @canvas

  remove : () ->
    @canvas.remove()
    delete fbg.canvas

window.fbg ?= {}
window.fbg.Canvas = Canvas