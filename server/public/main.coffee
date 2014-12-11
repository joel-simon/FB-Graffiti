'use strict'
window.fbg ?= {}

# fbg.host = 'https://54.69.196.168/'
fbg.host = 'https://localhost/'
fbg.cache = new fbg.ImageCache()

fbg.urlParser = 
  userImage : (src) -> src.match(/(profile).*\/[0-9]+_([0-9]+)_[0-9]+/)
  userContent : (src) -> src.match(/(sphotos|scontent).*\/[0-9]+_([0-9]+)_[0-9]+/)
  photoPage : (src) -> src.match(/www.facebook.com\/photo.php?/)
  id : (src) -> src.match(/\/[0-9]+_([0-9]+)_[0-9]+/)

fbg.get =
  mainImg : () -> $('.spotlight')
  faceBoxes : () -> $('.faceBox')
  photoUi : () -> $('.stageActions, .faceBox, .highlightPager')


$ () ->
  fbg.drawTools = new fbg.DrawTools()
  fbg.currentPage = location.href
  fbg.onPageLoad()
  trackChanges()
  

# triggered anytime new dom is loaded.
fbg.onPageLoad = () ->
  onNewPage = (location.href != fbg.currentPage)
  onPhotoPage = fbg.urlParser.photoPage(location.href)?
  # console.log 'onLoad', { onNewPage, onPhotoPage }
  fbg.currentPage = location.href

  if onNewPage
    fbg?.canvas?.remove()
    if onPhotoPage
      fbg.get.faceBoxes().hide()
      mainImg = fbg.get.mainImg()
      id = fbg.urlParser.userContent(mainImg[0].src)[2]
      fbg.cache.break id
      url = fbg.cache.idToUrl id
      
      fbg.canvas = new fbg.FbgCanvas(mainImg, id, url)
      fbg.canvas.addTo $('.stage')

      fbg.drawTools.show()
    else
      fbg.drawTools.hide()
  else # check for new images that have been labled.
    convertAllImages document.body

trackChanges = () ->
  domCoolTest = new fbg.DomCoolTest fbg.onPageLoad, 300
  $(document).on "DOMSubtreeModified", domCoolTest.warm

convertAllImages = (base) ->
  $(base).find('img').not('.hasGraffiti').not('.spotlight').each () ->
    id = fbg.urlParser.id @src
    img = $(@)
    return unless id?
    id = id[1]
    url = fbg.cache.idToUrl id
    return if url is null
    new fbg.FbgImg(img, id, url)