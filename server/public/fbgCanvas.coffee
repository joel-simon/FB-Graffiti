class FbgCanvas
  constructor : (@img, @id, url) ->
    @changesMade = false
    @img.addClass 'hasCanvas'
    @img.addClass 'hasGraffiti'
    @stage = $('.stage').first()

    top = "#{(@stage.height() - @img.height())//2}px"
    left = "#{(@stage.width() - @img.width())//2}px"
    width = @img.width()
    height = @img.height()

    @canvas = $('<canvas>')
      .attr({ id: "canvas#{@id}", width, height })
      .css({ position: 'absolute', top, left, cursor: "crosshair", 'z-index': 2 })
      .click (e) ->
        e.stopPropagation()
    @ctx = @canvas[0].getContext '2d'

    @graffitiImage = $('<img>')
      .attr({
        src : url
        id: "#{@id}img"
        'crossOrigin': 'anonymous'
      }).css({ position: 'absolute', width, height, top, left })
      .error(() =>
        @img.removeClass 'hasGraffiti'
        @graffitiImage.remove())
      .click (e) ->
        e.stopPropagation()

  draw : ({ prevX, prevY, currX, currY }) ->
    @changesMade = true
    @ctx.beginPath()
    @ctx.moveTo prevX, prevY
    @ctx.lineTo currX, currY
    @ctx.strokeStyle = $('.sp-preview-inner').css('background-color')
    @ctx.lineCap = 'round'
    @ctx.lineWidth = 4
    @ctx.stroke()
    @ctx.closePath()

  addTo : (div) ->
    div.prepend @graffitiImage
    div.prepend @canvas

  remove : () ->  
    if @changesMade
      img = @canvas[0].toDataURL()
      @postToServer { id : @id, img }, 'setImage'
      @addToOtherCopies img

    @canvas.remove()
    @graffitiImage.remove()
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
      ctx.drawImage @graffitiImage[0], 0, 0, width, height
      ctx.drawImage @canvas[0], 0, 0, width, height

      newImage = newImageCanvas[0].toDataURL()
      fbg.cache.add @id, newImage

      $(".img"+@id).not('.spotlight').each () ->
        img = $(this)

        # new fbg.FbgImg(img, @id, canvasImg)
        img.attr({ src: newImage })

    else #if image currently has no graffiti then add it
      console.log 'hasNoGraffiti'
      fbg.cache.add @id, canvasImg
      id = @id
      $(document.body).find('img').not('.hasGraffiti').not('.spotlight').each () ->
        img = $(@)
        _id = fbg.urlParser.id @src
        return unless _id
        if _id[1] == id
          new fbg.FbgImg(img, id, canvasImg)

window.fbg ?= {}
window.fbg.FbgCanvas = FbgCanvas