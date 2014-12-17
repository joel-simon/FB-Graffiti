class FbgCanvas
  constructor : (@img, @id, url) ->
    @changesMade = false
    @img.addClass 'hasCanvas'
    # @img.addClass 'hasGraffiti'
    @stage = $('.stage').first()

    top = "#{(@stage.height() - @img.height())//2}px"
    left = "#{(@stage.width() - @img.width())//2}px"
    width = @img.width()
    height = @img.height()

    @canvas = $('<canvas>')
      .attr({ id: "canvas#{@id}", width, height })
      .css({ position: 'absolute', top, left, cursor: "crosshair", 'z-index': 2 })
      .addClass('canvas')
      .click (e) -> e.stopPropagation()
    @ctx = @canvas[0].getContext '2d'

    @graffitiImage = $('<img>').attr({
        src : url
        id: "#{@id}img"
        'crossOrigin': 'anonymous'
      })
      .load () =>
        @img.addClass 'hasGraffiti'
        @ctx.drawImage @graffitiImage[0], 0, 0, width, height

  draw : ({ prevX, prevY, currX, currY }) ->
    r = fbg.drawTools.size()
    @changesMade = true
    @ctx.beginPath()
    @ctx.moveTo prevX+r, prevY+r
    @ctx.lineTo currX+r, currY+r
    @ctx.strokeStyle = fbg.drawTools.color()
    @ctx.lineCap = 'round'
    @ctx.lineWidth = r*2
    @ctx.stroke()
    @ctx.closePath()

  addTo : (div) ->
    # div.prepend @graffitiImage
    div.prepend @canvas

  remove : () ->  
    if @changesMade
      img = @canvas[0].toDataURL()
      @postToServer { id : @id, img }, 'setImage'
      @addToOtherCopies img

    @canvas.remove()
    # @graffitiImage.remove()
    @img.removeClass 'hasCanvas'
    delete fbg.canvas

  postToServer: (data, url) ->
    $.ajax { type:'POST', url: "#{fbg.host}setImage", data }

  addToOtherCopies: (canvasImg) ->
    # console.log 'adding to other copies', ".img"+@id
    
    #if an existing graffiti image, repalce it
    width = @img.width()
    height= @img.height()
    if @img.hasClass 'hasGraffiti'
      newImageCanvas = $('<canvas>').attr { width, height }
      ctx = newImageCanvas[0].getContext('2d')
      # ctx.drawImage @graffitiImage[0], 0, 0, width, height
      ctx.drawImage @canvas[0], 0, 0, width, height

      newImage = newImageCanvas[0].toDataURL()
      fbg.cache.add @id, newImage

      $(".img"+@id).not('.spotlight').each () ->
        img = $(this)
        img.attr({ src: newImage })

    else #if image currently has no graffiti then add it
      # console.log 'hasNoGraffiti'
      fbg.cache.add @id, canvasImg
      id = @id
      $(document.body).find('img').not('.hasGraffiti').not('.spotlight').each () ->
        img = $(@)
        _id = fbg.urlParser.id @src
        return unless _id
        if _id[1] == id
          new fbg.FbgImg(img, id, canvasImg)

  getColor: (x, y, cb) ->
    console.log {x, y}
    src = @img[0].src
    # console.log('src:', src);
    repeat = new Image    
    repeat.crossOrigin = "Anonymous"
    repeat.onload = () =>
      buffer = document.createElement('canvas');
      buffer.width = @img.width()
      buffer.height = @img.height()
      ctx = buffer.getContext "2d"
      ctx.drawImage repeat, 0, 0
      [r, g, b, a] = (ctx.getImageData x, y, 1, 1).data
      rbga = { r, g, b, a }
      cb null, rbga
    repeat.src = src

window.fbg ?= {}
window.fbg.FbgCanvas = FbgCanvas