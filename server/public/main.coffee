'use strict'
fbg = window.fbg ?= {}

$ () -> fbg.main()

fbg.main = () ->
  console.log 'main'
  fbg.randSrc = 'http://practicinganthropology.org/wp-content/uploads/2010/08/napa-mark-transparent-860x860.png'
  fbg.lastloc = location.href

  fbg.onPageLoad()
  trackChanges()
  setInterval ( () -> 
    if fbg.lastloc != location.href
      fbg.lastloc = location.href
      fbg.onPageLoad()
    ), 50

trackChanges = () ->
  domCoolTest = null
  $(document).on  "DOMSubtreeModified", (a,b,c) ->
    if domCoolTest?
      domCoolTest.warm()
    else
      onCool = () -> 
        convertAllImages document
      domCoolTest = new DomCoolTest 300, onCool
    

class DomCoolTest
  constructor: (@t, @cb) ->
    @timer = setTimeout @cb, @t
  warm : () ->
    clearTimeout @timer
    @timer = setTimeout @cb, @t

fbg.onPageLoad = () ->
  fbg = fbg
  fbg?.canvas?.remove()

  if fbg.urlParser.isPhotoPage(location.href)
    fbg.canvas = new fbg.Canvas(fbg.get.mainPhoto(), '123')
    fbg.canvas.addTo $('.stage')
  else
    convertAllImages document

fbg.urlParser = 
  isUserImage : (src) -> src.match(/profile.*\/[0-9]+_[0-9]+_[0-9]+/)?
  isUserContent : (src) -> src.match(/(sphotos|scontent).*\/[0-9]+_[0-9]+_[0-9]+/)?
  isPhotoPage : (src) -> src.match(/www.facebook.com\/photo.php?/)?

fbg.get =
  mainPhoto : () -> $('.spotlight')
  faceBoxes : () -> $('.faceBox')
  photoUi : () -> $('.stageActions, .faceBox, .highlightPager')

convertAllImages = (base) ->

  $(base)
    .find('img').get()
    .filter((img) -> 
      !$(img).hasClass('covered') and fbg.urlParser.isUserImage img.src )
    .forEach((img) -> 
      img = $(img)
      img.addClass('covered')
      width = img.width()
      height = img.height()
      fbgImg = $('<img id="dynamic">')
              .attr('src', fbg.randSrc)
              .css({width, height, position: 'absolute'})
      img.parent().prepend fbgImg
    )
  $(base)
    .find('img').get()
    .filter((img) -> 
      !$(img).hasClass('covered') and fbg.urlParser.isUserContent img.src )
    .forEach((img) ->
      img = $(img)
      img.addClass('covered')
      img.css position:'absolute'
      width = img.width()
      height = img.height()
      fbgImg = $('<img id="dynamic">')
              .attr('src', fbg.randSrc)
              .css({width, height, position: 'absolute'})
      img.parent().append fbgImg
    )

class FBGimg
  constructor: (@img) ->
