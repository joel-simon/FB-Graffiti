picker = $('<div></div>')
  .attr({id : 'picker'})
  .css({ 
    width : '200px'
    height: '200px'
    position: 'fixed'
    top: '42px'
    left:'30px'
    'z-index': 9999999 #crazy shit high, dont fck with me fb
  }).prependTo $(document.body)

slider = $('<div></div>')
  .attr({id : 'slider'})
  .css({ 
    width : '30px'
    height: '200px'
    position: 'fixed'
    top: '42px'
    'z-index': 9999998 #crazy shit high, dont fck with me fb
  }).prependTo $(document.body)

ColorPicker(
  document.getElementById('slider'),
  document.getElementById('picker'),
  (hex, hsv, rgb) ->
    fbg.color = hex
    $('#globalContainer').css('backgroundColor', hex)

  )

window.fbg ?= {}
window.fbg.hideDrawTools = () ->
  $('#slider,#picker').hide()

window.fbg.showDrawTools = () ->
  $('#slider,#picker').show()
