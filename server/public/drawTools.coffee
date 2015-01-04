class fbg.DrawTools
  constructor: () ->
    # @drawing = false
    @selectorOpen = false
    @eyeDropping = false

    @stageUI = $('.snowliftPager,.stageActions')

    @container = $('<div>')
      .css({ height: 30, margin: 4, position: 'absolute', cursor: 'pointer' })
      .prependTo $(document.body)
    
    @selectors = $('<div>').css('float', 'left').appendTo @container
    @selectors.hide()

    $('<input type="range" id="brushRange" value="90">')
        .css { width: 60, float: 'left' }
        .prependTo @selectors
        .click (e) -> e.stopPropagation()
        .change () => @updateCursor()

    dropper = $('<img>').attr { id: 'dropper', src: 'http://simpleicon.com/wp-content/uploads/eyedropper-64x64.png' }
      .prependTo @selectors
      .click () => 
        color = if @eyeDropping then 'white' else 'black'
        dropper.css 'border-color', color
        @eyeDropping = !@eyeDropping
        @updateCursor()

    $("<input type='text'/>")
      .attr({ id:'custom' })
      .prependTo @selectors
      .spectrum({
        color: "#000"
        change: (c) => @updateCursor()
        show: () => 
          @selectorOpen = true
        hide: () =>
          @selectorOpen = false
          @updateCursor()
       })

    showGraffitiButton = $('<button id="toggleG">Hide Graffiti</button>')
      .css { float: 'left', width: 80 }
      .prependTo @container
      .click () ->
        if fbg.showGraffiti
          $(@).text('Show')
          fbg.canvas.hide()
        else
          $(@).text('Hide graffiti')
          fbg.canvas.show()
        fbg.showGraffiti = !fbg.showGraffiti

    drawButton = $('<button id="toggleDrawing"></button>')
      .text if fbg.drawing then 'Stop drawing.' else 'Draw'
      .css { float: 'left', width: 80 }
      .prependTo @container
      .click () =>
        if fbg.drawing
          @stageUI.show()
          drawButton.text 'Draw'
        else
          @stageUI.hide()
          drawButton.text 'Stop drawing.'
        @selectors.toggle()
        if !fbg.showGraffiti and fbg.drawing is false
          showGraffitiButton.trigger 'click'
        fbg.drawing = !fbg.drawing
        @updateCursor()

    fbg.mouse.addListener 'mousemove', ({currX, currY, onCanvas}) =>
      if @eyeDropping and onCanvas
        c = fbg.canvas.getColor currX, currY
        @setColor c

    fbg.mouse.addListener 'mousedown', ({onCanvas}) =>
      if @eyeDropping and onCanvas
        dropper.trigger 'click'
    
    @hide()

  hide: () ->
    $('#custom').spectrum("hide");
    @container.hide()

  show: () ->
    $('.rhcHeader').css('height', 40).prepend @container
    $('#toggleG').text('Hide graffiti')
    @updateCursor()
    @container.show()

  setColor: (c) ->
    $('#custom').spectrum('set', c)

  color: () ->
    t = $('#custom').spectrum 'get'
    if t? then t.toRgbString() else "rgba(255, 0, 0, 0)"

  size: () ->
    parseInt($('#brushRange')[0]?.value) // 3

  # mouseMove: (x, y) ->
  #   if @eyeDropping
  #     @updateCursor(fbg.canvas.getColor x, y)

  updateCursor: (color) ->
    if !fbg.drawing
      $('.canvas').css { 'cursor': 'default' }
    else if @eyeDropping
      $('.canvas').css { 'cursor': 'crosshair' }
    else
      color ?= @color()
      # console.log 'udateCursor', color
      cursor = document.createElement 'canvas'
      ctx = cursor.getContext '2d'

      size = @size()
      cursor.width = size*2
      cursor.height = size*2

      ctx.beginPath()
      ctx.arc size, size, size, 0, 2 * Math.PI, false
      ctx.fillStyle = color
      ctx.fill()
      ctx.lineWidth = 1
      ctx.strokeStyle = '#000000'
      ctx.stroke()
      $('.canvas').css { 'cursor': "url(#{cursor.toDataURL()}) #{size} #{size}, auto" }
