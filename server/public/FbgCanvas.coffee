class fbg.FbgCanvas
  constructor : (@img, @id, url) ->
    @changesMade = false
    @img.addClass 'hasCanvas'
    @stage = $('.stage').first()
    @owner = fbg.get.owner() or fbg.urlParser.owner(fbg.currentPage)
    @history = []

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

    @createImgCopy()

  saveState: () ->
    @history.push @canvas[0].toDataURL()
    fbg.drawTools.undoButton.prop "disabled",false

  undo: () ->
    restore_state = @history.pop()
    return unless restore_state?
    img = new Image
    w = @canvas[0].width
    h = @canvas[0].height
    if @history.length == 0
      @changesMade = false
    img.onload = () =>
      @ctx.clearRect 0, 0, w, h
      @ctx.drawImage img, 0, 0, w, h
    img.src = restore_state

    null

  resize: () ->
    width = @img.width()
    height = @img.height()
    @canvas.attr { width, height }
    if @img.hasClass 'hasGraffiti'
      @ctx.drawImage @graffitiImage[0], 0, 0, width, height
    # @ctx.drawImage @graffitiImage[0]

  draw : ({ prevX, prevY, currX, currY }) ->
    return if fbg.drawTools.selectorOpen
    @changesMade = true
    
    r = fbg.drawTools.size()
    @ctx.beginPath()
    @ctx.moveTo prevX, prevY
    @ctx.lineTo currX, currY
    @ctx.strokeStyle = fbg.drawTools.color()
    @ctx.lineCap = 'round'
    @ctx.lineWidth = r*2
    @ctx.stroke()
    @ctx.closePath()

  addTo: (div) ->
    div.prepend @canvas

  remove: () ->
    @hide()
    if @changesMade
      img = @canvas[0].toDataURL()
      @postToServer img
      @addToOtherCopies img

    @canvas.remove()
    fbg.drawTools.hide()
    @img.removeClass 'hasCanvas'
    delete fbg.canvas

  hide: () ->
    @canvas.hide()
  show: () ->
    @canvas.show()

  postToServer: (img) ->
    return unless @changesMade
    img ?= @canvas[0].toDataURL()
    data =
      id: @id
      img: img
      url: @img.attr 'src'
      owner: @owner
    error = (XHR, err) ->
      console.log "There was an error posting to server #{err}"
    $.ajax { type:'POST', url: "#{fbg.host}setImage", data, error }

  addToOtherCopies: (canvasImg) ->
    width = @img.width()
    height= @img.height()
    if @img.hasClass 'hasGraffiti' #if tbere is an existing graffiti image
      newImageCanvas = $('<canvas>').attr { width, height }
      ctx = newImageCanvas[0].getContext('2d')
      # ctx.drawImage @graffitiImage[0], 0, 0, width, height
      ctx.drawImage @canvas[0], 0, 0, width, height

      newImage = newImageCanvas[0].toDataURL()
      fbg.cache.add @id, newImage
      # console.log 'new image is', newImage
      $(".img"+@id).not('.spotlight').each () ->
        img = $(this)
        img.attr({ src: newImage })

    else #if first graffiti on image
      fbg.cache.add @id, canvasImg
      id = @id
      $(document.body).find('img').not('.hasGraffiti').not('.spotlight').each () ->
        img = $(@)
        _id = fbg.urlParser.id @src
        return unless _id
        if _id[1] == id
          new fbg.FbgImg(img, id, canvasImg)

  createImgCopy: () ->
    src = @img[0].src
    copy = new Image    
    copy.crossOrigin = "Anonymous"
    copy.onload = () =>
      buffer = document.createElement('canvas');
      buffer.width = @img.width()
      buffer.height = @img.height()
      @ctxCopy = buffer.getContext "2d"
      @ctxCopy.drawImage copy, 0, 0, @img.width(), @img.height()
    copy.src = src

  getColor: (x, y) ->  
    [r, g, b, a] =  @ctx.getImageData(x, y, 1, 1).data
    return "rgb(#{r}, #{g}, #{b})" if a is 255

    [r, g, b, a] = @ctxCopy.getImageData(x, y, 1, 1).data
    "rgb(#{r}, #{g}, #{b})"