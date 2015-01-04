$ () ->
  data = {}
  parent = $('.notifCentered')
  div = $('<div>').addClass('_4962')
  visible = false

  jewelButton = $('<img>').attr({
    id : 'foo'
    src : 'http://www.facebookGraffiti.com/sprayIcon.png'
  })

  width = 430
  left = -200

  flyout = $('<div>').attr({}).css({
    'z-index':10
    position: 'absolute'
    'margin-top': 3
    }).hide()


  picker = $( '<div>
    <h1>Graffiti on your photos.</h1>
    </div>').css({
        position: 'relative'
        left: left
        width: width
        'background-color': 'white'
        'z-index': 11
        'border-left-style': 'solid'
        'border-color': 'grey'
        'border-width': 2
      }).appendTo flyout

  iframeCss = {
    width: width
    height: 500
    position: 'relative'
    left: left
    'background-color': 'white'
    'border-top-style': 'none'
  }

  myPhotos = $('<iframe />', {
    src: 'https://fb-graffiti.com/browse?u='+fbg.urlParser.myId()
  }).css(iframeCss).appendTo flyout


  div.append jewelButton
  div.append flyout
  parent.prepend div

  $('#myG').click () ->
    myPhotos.show()
    global.hide()
  $('#globalG').click () ->
    myPhotos.hide()
    global.show()

  jewelButton.click () ->
    if visible
      jewelButton.attr {src: 'http://www.facebookGraffiti.com/sprayIcon.png'}
      flyout.hide()  
    else
      jewelButton.attr {src: 'http://www.facebookGraffiti.com/sprayIconWhite.png'}
      flyout.show()
    visible = !visible
    

  $('.jewelButton').click () ->
    jewelButton.attr {src: 'http://www.facebookGraffiti.com/sprayIcon.png'}
    flyout.hide()