class fbg.DrawTools
  constructor: () ->
    @selectorOpen = false

    @container = $('<div>')
      .css({ height: 30, margin: 4, position: 'absolute' })
      .prependTo $(document.body)
    
    $('<input type="range" id="brushRange" value="90">')
        .css { width: 60, float: 'left' }
        .prependTo @container
        .click (e) -> e.stopPropagation()
        .change () => @updateCursor()

    $("<input type='text'/>")
      .attr({ id:'custom' })
      .prependTo @container
      .spectrum({ 
        color: "#000"
        # allowEmpty: true
        change: (c) => @updateCursor()
        show: () => 
          @selectorOpen = true
          $('.canvas').css { 'cursor': 'crosshair' }
        hide: () =>
          @selectorOpen = false
          @updateCursor()
       })

    graffitiVisible = true
    $('<button id="toggleG">Hide Graffiti</button>')
      .css { float: 'left', width: 80 }
      .prependTo @container
      .click () ->
        if graffitiVisible
          $(@).text('Show')
          fbg.canvas.hide()
        else
          $(@).text('Hide graffiti')
          fbg.canvas.show()
        graffitiVisible = !graffitiVisible
    @hide()

  hide: () ->
    $('#custom').spectrum("hide");
    @container.hide()

  show: () ->
    $('.rhcHeader').css('height', 40).prepend @container
    @container.find('button').text('Hide graffiti')
    @updateCursor()
    @container.show()

  setColor: ({r, g, b}) ->
    return unless @selectorOpen
    $('#custom').spectrum('set', "rgb(#{r}, #{g}, #{b})")
    # @updateCursor()

  color: () ->
    t = $('#custom').spectrum 'get'
    if t? then t.toRgbString() else "rgba(255,0,0,0)"

  size: () ->
    parseInt($('#brushRange')[0]?.value) // 3

  updateCursor: () ->
    cursor = document.createElement 'canvas'
    ctx = cursor.getContext '2d'

    size = @size()
    cursor.width = size*2
    cursor.height = size*2

    ctx.beginPath()
    ctx.arc size, size, size, 0, 2 * Math.PI, false
    ctx.fillStyle = @color()
    ctx.fill()
    ctx.lineWidth = 1
    ctx.strokeStyle = '#000000'
    ctx.stroke()

    $('.canvas').css { 'cursor':  'url(' + cursor.toDataURL() + '), auto' }