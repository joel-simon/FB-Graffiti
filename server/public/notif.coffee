data = {}
parent = $('.notifCentered')
div = $('<div>').addClass('_4962')

jewelButton = $('<img>').attr({
  id : 'foo'
  src : 'http://www.facebookGraffiti.com/sprayIcon.png'
})

flyout = $('<div>').attr({}).css({
  width: 300
  'min-height':100
  'z-index':1000
  position: 'absolute'
  'margin-top': 3
  })

$('<iframe />', {
  name: 'myFrame'
  id:   'myFrame'
  src: 'https://fb-graffiti.com/browse'
}).css({
  position: 'relative'
  left: -60
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