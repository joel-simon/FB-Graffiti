class ImageCache
  constructor: () ->
    @forced = {}
    @local = {}

  # After an image has been edited, we want to relaod it.
  break: (id) ->
    @forced[id] = true
    localStorage.setItem "fbgEmpty:#{id}", null

  #when we make a new drawing locally we save it
  add: (id, url) ->
    @local[id] = url

  doesntExist: (id) ->
    localStorage.setItem "fbgEmpty:#{id}", (Date.now() // 1000)

  past24Hours: (t) ->
    t > (Date.now() // 1000) - 24*60*60

  idToUrl: (id) ->
    s3Url = "https://s3.amazonaws.com/facebookGraffiti/"
    isEmpty = localStorage.getItem "fbgEmpty:#{id}"
    return @local[id] if @local[id]?
    return null if isEmpty? and @past24Hours(isEmpty)
    if @forced[id]
      q = "?dummy=#{(Math.random()+'').substr(2)}"
      @forced[id] = false
    "#{s3Url}#{id}.png#{q or ''}"

window.fbg ?= {}
window.fbg.ImageCache = ImageCache
