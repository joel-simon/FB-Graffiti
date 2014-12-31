data = {}
parent = $('.notifCentered')
div = $('<div>').addClass('_4962')

jewelButton = $('<img>').attr({
  id : 'foo'
  src : 'http://www.facebookGraffiti.com/sprayIcon.png'
})

flyout = $('<div>').attr({}).css({
  'z-index':1000
  position: 'absolute'
  'margin-top': 3
  }).hide()

$('<iframe />', {
  name: 'myFrame'
  id:   'myFrame'
  src: 'https://fb-graffiti.com/browse'
}).css({
  width: 410
  height: 500
  position: 'relative'
  left: -200
}).appendTo flyout

div.append jewelButton
div.append flyout
parent.prepend div

jewelButton.click () ->
  flyout.toggle()
#   flyout = $('<div>').attr({
#     id: 'fbNotificationsFlyout'
#   }).addClass('__tw').addClass('uiToggleFlyout').addClass('_4xi1')
#   console.log flyout
#   div.append flyout