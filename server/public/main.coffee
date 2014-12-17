window.fbg ?= {}
fbg.host = 'https://fb-graffiti.com/'

fbg.urlParser = 
  userImage : (src) -> src.match(/(profile).*\/[0-9]+_([0-9]+)_[0-9]+/)
  userContent : (src) -> src.match(/(sphotos|scontent).*\/[0-9]+_([0-9]+)_[0-9]+/)
  photoPage : (src) -> 
    src.match(/www.facebook.com\/photo.php?/) or 
    src.match(/www.facebook.com\/.*\/photos/)
  id : (src) -> src.match(/\/[0-9]+_([0-9]+)_[0-9]+/)
  stupidCroppedPhoto: (src) -> src.match(/p\d+x\d+/)


fbg.get =
  mainImg : () -> $('.spotlight')
  faceBoxes : () -> $('.faceBox')
  photoUi : () -> $('.stageActions, .faceBox, .highlightPager')

fbg.isCoverPhoto = (img) ->
  img.parent().parent().attr('id') is 'fbProfileCover'

# triggered anytime new dom is loaded.
fbg.onPageLoad = () ->
  onNewPage = (location.href != fbg.currentPage)
  onPhotoPage = fbg.urlParser.photoPage(location.href)?
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
    # return if fbg.urlParser.stupidCroppedPhoto(@src)?

    id = fbg.urlParser.id @src
    img = $(@)
    return if fbg.isCoverPhoto img
    return unless id?
    id = id[1]
    url = fbg.cache.idToUrl id
    return if url is null
    new fbg.FbgImg(img, id, url)

$ () ->
  console.log 'Hello from Fracebook Graffiti'
  fbg.cache = new fbg.ImageCache()
  fbg.drawTools = new fbg.DrawTools()
  fbg.currentPage = location.href
  fbg.onPageLoad()
  trackChanges()

  