class fbg.DrawTools
  constructor: () ->
    # @drawing = false
    @selectorOpen = false
    @eyeDropping = false

    # @stageUI = $('.snowliftPager,.stageActions')

    @container = $('<div>')
      .css({ height: 50, margin: 4, position: 'absolute', cursor: 'pointer' })
    
    selectors = $('<div>').css 'float', 'left'
    utilities = $('<div>').css 'float', 'left'
    selectors.hide()

    rangePicker = $('<input type="range" id="brushRange" value="40">')
      .css { width: 60, float: 'left' }
      .click (e) -> e.stopPropagation()
      .change () => @updateCursor()

    dropper = $('<img>').attr { id: 'dropper', src: 'http://simpleicon.com/wp-content/uploads/eyedropper-64x64.png' }
      .css { float: 'left' }
      .click () => 
        color = if @eyeDropping then 'white' else 'black'
        dropper.css 'border-color', color
        @eyeDropping = !@eyeDropping
        @updateCursor()

    colorPicker = $("<input type='text'/>")
      .attr({ id:'custom' })
      .css { float: 'left' }
      .prependTo selectors
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
      .click () ->
        if fbg.showGraffiti
          $(@).text('Show')
          fbg.canvas.hide()
        else
          $(@).text('Hide graffiti')
          fbg.canvas.show()
        fbg.showGraffiti = !fbg.showGraffiti

    drawButton = $('<button id="toggleDrawing"></button>')
      .text if fbg.drawing then 'Stop' else 'Draw'
      .css { float: 'left', width: 80 }
      .click () =>
        if fbg.drawing
          fbg.get.faceBoxes().show()
          drawButton.text 'Draw'
          fbg.canvas.postToServer()
        else
          fbg.get.faceBoxes().hide()
          drawButton.text 'Stop'
        selectors.toggle()
        utilities.toggle()

        if !fbg.showGraffiti and fbg.drawing is false
          showGraffitiButton.trigger 'click'
        fbg.drawing = !fbg.drawing
        @updateCursor()

    reportButton = $('<button id="report">Report</button>')
      .css { float: 'left', width: 80 }
      .click () =>
        text = 'Does this graffiti contain any: 
        abuse, harrasment or egregiously offensive material?
        Remember, you can always remove graffiti from your own photos!
        For more information visit http://fbgraffiti.com/faq/'
        report = confirm text
        if report
          data = { id: fbg.canvas.id }
          $.ajax { type:'POST', url: "#{fbg.host}report", data }
          alert 'It will be evaluated and potentially removed, thanks.'
    
    @undoButton = $('<button id="undo" disabled>Undo</button>')
      .css { float: 'left', width: 80 }
      .click () => 
        fbg.canvas.undo()
        if fbg.canvas.history.length == 0
          @undoButton.prop "disabled",true

    downloadButton = $('<a id="downlaod">Download</a>')
      .css { float: 'left', width: 80 }
      .click () ->
        alert 'Tweet with #fbgraffiti or @fb_graffiti!'
        @href = fbg.canvas.export()
        @download = fbg.canvas.id+'.png'

    # donate = $('<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
    #             <input type="hidden" name="cmd" value="_s-xclick">
    #             <input type="hidden" name="hosted_button_id" value="RYVAZPEYTZ7W8">
    #             Help Support FB GRaffiti!</form>')
    #           .css({
    #             'margin-left': 'auto'
    #             'margin-right': 'auto'
    #           })
              #<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
              #<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">




    dropper.prependTo selectors
    rangePicker.prependTo selectors

    @undoButton.appendTo selectors

    showGraffitiButton.appendTo utilities
    reportButton.appendTo utilities
    downloadButton.appendTo utilities

    drawButton.appendTo @container
    selectors.appendTo @container
    utilities.appendTo @container
    # donate.appendTo @container

    @container.prependTo $(document.body)

    fbg.mouse.addListener 'mousemove', ({currX, currY, onCanvas}) =>
      if @eyeDropping and onCanvas
        c = fbg.canvas.getColor currX, currY
        @setColor c

    fbg.mouse.addListener 'mousedown', ({onCanvas}) =>
      $('#custom').spectrum("hide")
      # console.log onCanvas, @eyeDropping
      if @eyeDropping and onCanvas
        dropper.trigger 'click'
    
    @hide()

  hide: () ->
    $('#custom').spectrum("hide")
    @undoButton.prop "disabled", true
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
    (parseInt($('#brushRange')[0]?.value) / 3)+2

  updateCursor: (color) ->
    if !fbg.drawing
      $('.canvas').css { 'cursor': 'default' }
    else if @eyeDropping
      $('.canvas').css { 'cursor': 'crosshair' }
    else
      cursor = document.createElement 'canvas'
      ctx = cursor.getContext '2d'
      color = $('#custom').spectrum('get')
      size = @size()
      cursor.width = size*2
      cursor.height = size*2

      ctx.beginPath()
      ctx.arc size, size, size, 0, 2 * Math.PI, false
      ctx.fillStyle = color.toRgbString()
      ctx.fill()
      ctx.lineWidth = 1
      ctx.strokeStyle = if color.getBrightness() > 100 then '#000000' else '#FFFFFF'
      ctx.stroke()
      $('.canvas').css { 'cursor': "url(#{cursor.toDataURL()}) #{size} #{size}, auto" }