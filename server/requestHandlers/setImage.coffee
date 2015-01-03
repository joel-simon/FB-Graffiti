db = require '../adapters/db'
s3 = require '../adapters/s3'
async = require 'async'
images = require 'images'

module.exports = (req, res) ->
  { id, img, url, owner } = req.body
  if !id or !img or !url or !owner
    console.log 'Invalid setImage post params:', {id, img: !!img, url: !!url, owner}
    return res.send 400
  path = "#{id}.png"

  formatted = img.replace /^data:image\/\w+;base64,/, ""
  delta = images new Buffer(formatted, 'base64')
  start = new Date().getTime()
  
  s3.getImage { bucket: 'facebookGraffiti', path }, (err, data) ->
    options = { res, path, start, delta, data, url, owner }
    if err then newImage options else existingImage options

newImage = (options) ->
  console.log 'newImage', delta
  options.type = 'new'
  options.width = delta.width()
  options.height = delta.height()
  options.img = (delta).encode 'png'
  done options

existingImage = ({ res, path, start, delta, data, url, owner }) ->
  console.log 'Existing image'
  type = 'append'
  oldImg = images data.Body
  oldWidth = oldImg.width()
  oldHeight = oldImg.height()
  dWidth = delta.width()
  dHeight = delta.height()
  width = oldWidth
  height = oldHeight
  if (dHeight > oldHeight && dWidth == oldWidth) # need to englarge image.
    img = images(dWidth, dHeight).draw(oldImg,0,0).draw(delta,0,0).encode("png")
    height = dHeight
  else if (dHeight != oldHeight or dWidth != oldWidth)
    img = oldImg.draw(delta.size(oldWidth, oldHeight),0,0).encode("png")
  else
    img = oldImg.draw(delta,0,0).encode "png"
  done { res, img, path, start, width, height, type, url, owner }

done = ({ res, img, path, start, width, height, type, url, owner }) ->
  time = (new Date().getTime()) - start
  id = path.split('.')[0]
  s3.putImage { bucket: 'facebookGraffiti', img, path }, (err) ->
    if err?
      console.log "ERR:#{JSON.stringify(err)}"
      return res.send 400

    console.log {id, img: !!img, url: !!url, owner}

    q1 =  "UPDATE graffiti set url = $2::text, owner = $3 WHERE id = $1::text;"
    qfu = "INSERT INTO graffiti (id, url, owner) SELECT '#{path.split('.')[0]}', '#{url}', '#{owner}' WHERE NOT EXISTS (select 1 from graffiti where id = $1); "

    q2 = 'INSERT INTO events (time_taken, id, width, height, type)
          VALUES ($1,$2,$3,$4,$5)'

    v1 = [ id, url, owner ]
    v2 = [time, id, width, height, type ]
    async.series [
      (cb) -> db.query q1, v1, cb
      (cb) -> db.query qfu, [ path.split('.')[0] ], cb
      (cb) -> db.query q2, v2, cb
    ], (err) ->
      if err?
        console.log "Error querying: #{JSON.stringify(err)}"
        res.send 400
      else
        res.send 200