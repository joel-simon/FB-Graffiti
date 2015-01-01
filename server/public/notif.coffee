$ () ->
  data = {}
  parent = $('.notifCentered')
  div = $('<div>').addClass('_4962')

  jewelButton = $('<img>').attr({
    id : 'foo'
    src : 'http://www.facebookGraffiti.com/sprayIcon.png'
  })

  width = 410
  left = -200

  flyout = $('<div>').attr({}).css({
    'z-index':10
    position: 'absolute'
    'margin-top': 3
    }).hide()


  picker = $( '<div class="toggle-btn-grp joint-toggle">
      <label id="myG" class="toggle-btn"><input type="radio" name="group3"/>My Images</label>
      <label id="globalG" class="toggle-btn success"><input type="radio" name="group3"/>Global</label>
    </div>').css({
        position: 'relative'
        left: left
        width: width
        'background-color': 'white'
        'z-index': 11
      }).appendTo flyout

  iframeCss = {
    width: width
    height: 500
    position: 'relative'
    left: left
    'background-color': 'white'
  }

  myPhotos = $('<iframe />', {
    src: 'https://fb-graffiti.com/browse?u='+fbg.urlParser.myId()
  }).css(iframeCss).hide().appendTo flyout

  global = $('<iframe />', {
    src: 'https://fb-graffiti.com/browse'
  }).css(iframeCss).appendTo flyout

  div.append jewelButton
  div.append flyout
  parent.prepend div

  $(".toggle-btn:not('.noscript') input[type=radio]").addClass("visuallyhidden")
  $(".toggle-btn:not('.noscript') input[type=radio]").change () ->
    if $(this).attr("name")
        $(this).parent().addClass("success").siblings().removeClass("success")
    else
        $(this).parent().toggleClass("success")

  $('#myG').click () ->
    myPhotos.show()
    global.hide()
  $('#globalG').click () ->
    myPhotos.hide()
    global.show()

  jewelButton.click () ->
    flyout.toggle()
  #   flyout = $('<div>').attr({
  #     id: 'fbNotificationsFlyout'
  #   }).addClass('__tw').addClass('uiToggleFlyout').addClass('_4xi1')
  #   console.log flyout
  #   div.append flyout