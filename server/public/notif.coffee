$ () ->
  data = {}
  parent = $('.notifCentered')
  
  jewelSrc = fbg.imgHost+'sprayIcon.png'
  jewelSrcWhite = fbg.imgHost+'sprayIconWhite.png'
  visible = false

  jewelButton = $('<div>').addClass('_4962')
  jewel = $('<img />', { src : jewelSrc })
  jewelButton.append jewel

  countBox = $('<div />').css({
    position: 'absolute'
    top: -4
    left: 20
    'background-color': 'red'
    height: 20
    'border-radius': 3
    display: 'none'
  })
  countText = $('<p>3</p>').css({
    color: 'white'
    margin: 4
  })
  countBox.append countText
  jewelButton.append countBox

  # $("<style type='text/css'> .redbold{ color:#f00; font-weight:bold;} </style>").appendTo("head");

  width = 430
  left = -200

  flyout = $('<div>').attr({}).css({
    'z-index':10
    position: 'absolute'
    'margin-top': 3
    }).hide()

  picker = $( '<div><h1>Graffiti on your photos.</h1></div>').css({
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
    src: fbg.host+'browse?u='+fbg.urlParser.myId()
  }).css(iframeCss).appendTo flyout

  jewelButton.append flyout
  parent.prepend jewelButton

  $('#myG').click () ->
    myPhotos.show()
    global.hide()
  $('#globalG').click () ->
    myPhotos.hide()
    global.show()

  jewelButton.click () ->
    countBox.hide()
    if visible
      jewel.attr {src: jewelSrc}
      flyout.hide()  
    else
      jewel.attr {src: jewelSrcWhite}
      flyout.show()
    visible = !visible
    

  $('.jewelButton').click () ->
    jewelButton.attr {src: jewelSrc}
    flyout.hide()

  lastLogin = localStorage.getItem("FbgLastLogin") or 'Sat Jan 03 2015 23:24:39 GMT-0500 (EST)'
  lastLogin = lastLogin?.split(' ').join('_')
  id = fbg.urlParser.myId()
  localStorage.setItem "FbgLastLogin", new Date()
  $.get "#{fbg.host}notifCount?id=#{id}&last=#{lastLogin}", (data) ->
    if parseInt(data) > 0
      countText.text data
      countBox.show()



  

