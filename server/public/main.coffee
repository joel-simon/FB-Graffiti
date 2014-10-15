'use strict'
fbg = window.fbg ?= {}

$ () -> fbg.main()

prevX = 0
currX = 0
prevY = 0
currY = 0
flag = null
dot_flag = null

fbg.main = () ->
  console.log 'main'
  fbg.randSrc = 'http://practicinganthropology.org/wp-content/uploads/2010/08/napa-mark-transparent-860x860.png'
  fbg.onPageLoad()
  trackChanges()
  fbg.currentPage = location.href
  document.addEventListener "mousemove", ((e) -> findxy('move', e)), false
  document.addEventListener "mousedown", ((e) -> findxy('down', e)), false
  document.addEventListener "mouseup",  ((e) -> findxy('up',   e)), false
  document.addEventListener "mouseout", ((e) -> findxy('out',  e)), false

findxy = (res, e) ->

  return if !fbg.canvas?
  return if e.target != fbg.canvas.canvas[0]

  console.log res
  ctx = fbg.canvas.canvas[0].getContext('2d');
  if res == 'down'
    prevX = currX
    prevY = currY

    currX = e.offsetX
    currY = e.offsetY
    flag = true;

  if flag && res == 'up' || res == "out"
      flag = false
  if res == 'move'
    if (flag)
      prevX = currX
      prevY = currY
      currX = e.offsetX
      currY = e.offsetY
      draw(ctx)
 draw = (ctx) ->
  console.log 'draw'
  # bumpTimer()
  # changesMade = true
  ctx.beginPath()
  ctx.moveTo(prevX, prevY)
  ctx.lineTo(currX, currY)
  ctx.strokeStyle = fbg.color ? 'black'
  ctx.lineCap = 'round'
  ctx.lineWidth = 4
  ctx.stroke()
  ctx.closePath()

fbg.urlParser = 
  userImage : (src) -> src.match(/profile.*\/[0-9]+_([0-9])+_[0-9]+/)
  userContent : (src) -> src.match(/(sphotos|scontent).*\/[0-9]+_([0-9]+)_[0-9]+/)
  photoPage : (src) -> src.match(/www.facebook.com\/photo.php?/)

notes = 
  pageheaer: "10201859094623936&set=a.1463653996240.2058441.1380180579"
  imgSrc : "1959934_10201859094623936_1792593057_n.jpg?oh=57b489db1b380b9dfceb8f5c415a1225&amp;oe=54C6DE50"
  fo: 'https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-xfa1/v/t1.0-9/10583964_10202856629641688_665853615174902840_n.jpg?oh=65dd0d3902b76e732f957ac2e4828173&amp;oe=54AF99AF&amp;__gda__=1421471268_e90137683d0219a7bf34261b9f19c816'

fbg.get =
  mainImg : () -> $('.spotlight')
  faceBoxes : () -> $('.faceBox')
  photoUi : () -> $('.stageActions, .faceBox, .highlightPager')

fbg.onPageLoad = () ->
  console.log 'onLoad'
  if location.href == fbg.currentPage
    onSamePage = true
   else
    onSamePage = false 
    fbg.currentPage = location.href
    fbg?.canvas?.remove()

  if fbg.urlParser.photoPage(location.href)? and !onSamePage
    fbg.get.faceBoxes().hide()
    mainImg = fbg.get.mainImg()
    id = fbg.urlParser.userContent(mainImg[0].src)[2]
    window.fbg.showDrawTools()
    fbg.canvas = new fbg.FbgCanvas(mainImg, id)
    fbg.canvas.addTo $('.stage')

  else if !onSamePage
    window.fbg.hideDrawTools()
    # convertAllImages document

trackChanges = () ->
  domCoolTest = new fbg.DomCoolTest(fbg.onPageLoad, 500)
  $(document).on "DOMSubtreeModified", domCoolTest.warm

convertAllImages = (base) ->
  # $(base)
  #   .find('img').get()
  #   .filter((img) -> 
  #     !$(img).hasClass('covered') and fbg.urlParser.isUserImage img.src )
  #   .forEach((img) -> 
  #     img = $(img)
  #     img.addClass('covered')
  #     width = img.width()
  #     height = img.height()
  #     fbgImg = $('<img id="dynamic">')
  #             .attr('src', fbg.randSrc)
  #             .css({width, height, position: 'absolute'})
  #     img.parent().prepend fbgImg
  #   )
  # $(base)
  #   .find('img').get()
  #   .filter((img) -> 
  #     !$(img).hasClass('covered') and fbg.urlParser.isUserContent img.src )
  #   .forEach((img) ->
  #     img = $(img)
  #     img.addClass('covered')
  #     img.css position:'absolute'
  #     width = img.width()
  #     height = img.height()
  #     fbgImg = $('<img id="dynamic">')
  #             .attr('src', fbg.randSrc)
  #             .css({width, height, position: 'absolute'})
  #     img.parent().append fbgImg
  #   )
