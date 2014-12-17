class fbg.DrawTools
  constructor: () ->
    @s = '.sp-replacer,#brushRange'

    $('<input type="range" id="brushRange" value="90">')
        .css { position: 'absolute', 'z-index': 999, width: 60, left: 60 }
        .prependTo $(document.body)
        .click (e) -> e.stopPropagation()
        .change () => @updateCursor()
    $("<input type='text'/>")
      .attr({ id:'custom' })
      .prependTo $(document.body)
      .spectrum({ 
        color: "#000"
        change: (c) => @updateCursor()
        # allowEmpty: true
       })
    @hide()

  hide: () ->
    $(@s).hide()

  show: () ->
    @updateCursor()
    $('.stage').prepend $(@s)
    $(@s).show()

  setColor: ({r, g, b}) ->
    $('#custom').spectrum('set', "rgb(#{r}, #{g}, #{b})")
    @updateCursor()

  color: () ->
    $('.sp-preview-inner').css('background-color')

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
    $('.canvas').css { 'cursor':  'url(' + cursor.toDataURL() + '), auto' }