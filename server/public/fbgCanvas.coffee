breakCache = {}

class FbgCanvas
  constructor : (@img, @key) ->
    console.log "Adding: #{@key}", fbg.getImgUrl @key
    @changesMade = false
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
        'z-index': 2
      }).click (e) ->
        e.stopPropagation()
    @ctx = @canvas[0].getContext '2d'

    @fbgImage = $('<img>')
      .attr({
        src : fbg.getImgUrl @key
        id: "#{@key}:img"
      }).css({ position: 'absolute', width, height, top, left })
      .click (e) ->
        e.stopPropagation()

  draw : ({ prevX, prevY, currX, currY }) ->
    @changesMade = true
    @ctx.beginPath()
    @ctx.moveTo prevX, prevY
    @ctx.lineTo currX, currY
    @ctx.strokeStyle = fbg.color ? 'black'
    @ctx.lineCap = 'round'
    @ctx.lineWidth = 4
    @ctx.stroke()
    @ctx.closePath()

  addTo : (div) ->
    div.prepend @fbgImage
    div.prepend @canvas

  remove : () ->
    domain = 'https://localhost/'
    console.log @changesMade
  
    if @changesMade
      fbg.breakCache[@key] = true
      data = 
        img : @canvas[0].toDataURL()
        key : @key

      $.ajax {
        type:'POST',
        url: domain+'setImage',
        data : data
        cache : false
        error: (data) -> console.log("error sending image..", data)
        cache : false
      }

    console.log "Removing: #{@key}"
    @canvas.remove()
    @fbgImage.remove()
    @img.removeClass 'hasCanvas'
    delete fbg.canvas

window.fbg ?= {}
window.fbg.FbgCanvas = FbgCanvas