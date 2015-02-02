fbg.host ?= 'https://fb-graffiti.com/'
fbg.imgHost = 'http://fbgraffiti.com/extensionimages/'
fbg.drawing = false
fbg.showGraffiti = true

fbg.urlParser = 
  userImage : (src) -> src.match(/(profile).*\/[0-9]+_([0-9]+)_[0-9]+/)
  userContent : (src) -> src.match(/(sphotos|scontent).*\/[0-9]+_([0-9]+)_[0-9]+/)
  photoPage : (src) -> 
    src.match(/www.facebook.com\/photo.php?/) or 
    src.match(/www.facebook.com\/.*\/photos/)
  id : (src) -> src.match(/\/[0-9]+_([0-9]+)_[0-9]+/)
  stupidCroppedPhoto: (src) -> src.match(/p\d+x\d+/)
  myId: () ->
    s = $("img[id^=profile_pic_header]")[0].id
    s?.match(/_([0-9]+)/)[1]
  owner: (url) ->
    # Type A
    # /photo.php?fbid=10204354908425219&set=t.100000157939878&type=1&theater
    # /vtechvsa/photos/t.100000157939878/582035031943331/?type=1&theater
    a = url.match(/t\.([0-9]+)/)
    # Type B
    # /photo.php?fbid=968579496490639&set=a.166770083338255.40807.100000157939878&type=1&theater
    # /vtechvsa/photos/a.582032565276911.1073741910.292031957610308/582035031943331/?type=1&theater
    b = url.match(/[0-9]+\.[0-9]+\.([0-9]+)/)
    (a and a[1]) or (b and b[1]) or null


fbg.get =
  mainImg : () -> $('.spotlight')
  faceBoxes : () -> $('.faceBox')
  photoUi : () -> $('.stageActions, .faceBox, .highlightPager')
  profileAndCover: () -> $('.profilePic, .coverPhotoImg')
  owner: () ->
    url = $('#fbPhotoSnowliftAuthorName').children().data()?.hovercard
    return null unless url?
    ownerId = url.match(/id=([0-9]+)/)
    return null unless ownerId?
    ownerId[1]



fbg.isCoverPhoto = (img) ->
  img.parent().parent().attr('id') is 'fbProfileCover'

# triggered anytime new dom is loaded.
fbg.onPageLoad = () ->
  onNewPage = (location.href != fbg.currentPage)
  onPhotoPage = fbg.urlParser.photoPage(location.href)?
  onHomePage = location.pathname == '/'
  fbg.currentPage = location.href

  if onNewPage
    fbg?.canvas?.remove()
    if onPhotoPage
      mainImg = fbg.get.mainImg()
      id = fbg.urlParser.userContent(mainImg[0].src)[2]
      fbg.cache.break id
      url = fbg.cache.idToUrl id
      fbg.canvas = new fbg.FbgCanvas(mainImg, id, url)
      fbg.canvas.addTo $('.stage')
      fbg.drawTools.show()
    else
      fbg.drawTools.hide()
      # if onHomePage
      #   console.log 'yo', fbg.addTrending
      fbg.addTrending()
  else # check for new images that have been labled.
    convertAllImages document.body

trackChanges = () ->
  domCoolTest = new fbg.DomCoolTest fbg.onPageLoad, 300
  $(document).on "DOMSubtreeModified", domCoolTest.warm

convertAllImages = (base) ->
  addGraffiti = () ->
    id = fbg.urlParser.id @src
    img = $(@)
    return unless id?
    id = id[1]
    url = fbg.cache.idToUrl id
    return if url is null
    new fbg.FbgImg(img, id, url)

  fbg.get.profileAndCover().each addGraffiti
  setTimeout (() ->
    $(base).find('img').not('.hasGraffiti').not('.spotlight').each addGraffiti),
    100


$ () ->
  # console.log 'Page loaded'
  fbg.mouse = new EventEmitter()
  fbg.drawTools = new fbg.DrawTools()
  $( window ).resize () -> fbg.canvas?.resize()
  fbg.addTrending()
  fbg.createNotif()
  fbg.mouse.addListener 'mousemove', (options) =>
    if fbg.drawing and options.onCanvas and options.dragging
      fbg.canvas?.draw options

  fbg.mouse.addListener 'mousedown', (options) =>
    if fbg.drawing and options.onCanvas
      fbg.canvas?.saveState()

# console.log 'Starting'
fbg.cache = new fbg.ImageCache()
fbg.currentPage = location.href
fbg.onPageLoad()
trackChanges()