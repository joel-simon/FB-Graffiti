'use strict'
fbg = window.fbg ?= {}

$ () -> 
  fbg.onPageLoad()
  trackChanges()
  fbg.currentPage = location.href

fbg.urlParser = 
  userImage : (src) -> src.match(/(profile).*\/[0-9]+_([0-9]+)_[0-9]+/)
  userContent : (src) -> src.match(/(sphotos|scontent).*\/[0-9]+_([0-9]+)_[0-9]+/)
  photoPage : (src) -> src.match(/www.facebook.com\/photo.php?/)
  id : (src) -> src.match(/\/[0-9]+_([0-9]+)_[0-9]+/)

fbg.get =
  mainImg : () -> $('.spotlight')
  faceBoxes : () -> $('.faceBox')
  photoUi : () -> $('.stageActions, .faceBox, .highlightPager')

# After an image has been edited, we want to relaod it.
fbg.breakCache = { }
fbg.getImgUrl = (key) ->
  s3Url = "https://s3.amazonaws.com/facebookGraffiti/"
  if fbg.breakCache[key]
    q = "?dummy=#{(Math.random()+'').substr(2)}"
    fbg.breakCache[key] = false
  "#{s3Url}#{key}.png#{q or ''}"

# triggered anytime new dom is loaded.
fbg.onPageLoad = () ->
  
  onNewPage = (location.href != fbg.currentPage)
  console.log 'onLoad', {onNewPage}
  onPhotoPage = fbg.urlParser.photoPage(location.href)?
  fbg.currentPage = location.href

  if onNewPage
    fbg?.canvas?.remove()
    if onPhotoPage
      fbg.get.faceBoxes().hide()
      mainImg = fbg.get.mainImg()
      id = fbg.urlParser.userContent(mainImg[0].src)[2]
      window.fbg.showDrawTools()
      fbg.canvas = new fbg.FbgCanvas(mainImg, id)
      fbg.canvas.addTo $('.stage')
      window.fbg.showDrawTools
    else
      window.fbg.hideDrawTools()
    # else
    #   convertAllImages document  
  # check for new images that have been labled.
  else
    convertAllImages document

trackChanges = () ->
  domCoolTest = new fbg.DomCoolTest(fbg.onPageLoad, 500)
  $(document).on "DOMSubtreeModified", domCoolTest.warm

convertAllImages = (base) ->
  $(base)
    .find('img').not('.covered').not('.spotlight').each () -> #.:not(covered)
      id = fbg.urlParser.id(this.src)
      return if !id?

      img = $(this)
      img.addClass('covered')
      if fbg.urlParser.userContent(img[0].src)?
        img.css position:'absolute'
      width = img.width()
      height = img.height()
      left = img.css('left') or 0
      top = img.css('top') or 0
      src = fbg.getImgUrl id[1]
      fbgImg = $('<img id="dynamic">')
                .attr('src', src)
                .css({width, height, left, top, position: 'absolute', 'z-index': 2})
                .error(() -> 
                  $(this).remove()
                )
      img.parent().prepend fbgImg
