db = require '../adapters/db'
s3 = require '../adapters/s3'
async = require 'async'
images = require 'images'

module.exports = (req, res) ->
  { id, img, url } = req.body
  if !id or !img or !url
    console.log 'Invalid setImage post params:', req.body
    return res.send 400

  path = "#{id}.png"

  formatted = img.replace /^data:image\/\w+;base64,/, ""
  delta = images new Buffer(formatted, 'base64')
  start = new Date().getTime()
  
  s3.getImage { bucket: 'facebookGraffiti', path }, (err, data) ->
    options = { res, path, start, delta, data, url }
    if err then newImage options else existingImage options

newImage = ({res, path, start, delta, url}) ->
  console.log 'newImage', delta
  type = 'new'
  width = delta.width()
  height = delta.height()
  img = (delta).encode 'png'
  done { res, img, path, start, width, height, type, url }

existingImage = ({res, path, start, delta, data, url }) ->
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
  done { res, img, path, start, width, height, type, url }

done = ({ res, img, path, start, width, height, type, url }) ->
  time = (new Date().getTime()) - start
  s3.putImage { bucket: 'facebookGraffiti', img, path }, (err) ->
    if err?
      console.log "ERR:#{JSON.stringify(err)}"
      return res.send 400
    
    q1a = 'UPDATE id_url set url = $2::text WHERE id = $1::text'

    q1b = 'INSERT INTO id_url(id, url) VALUES ($1, $2)'

    q2 = 'INSERT INTO events (time_taken, id, width, height, type)
          VALUES ($1,$2,$3,$4,$5)'

    v1 = [ path.split('.')[0], url ]
    v2 = [time, path.split('.')[0], width, height, type ]
    console.log v1
    q1 = if type is 'new' then q1b else q1a
    async.series [
      (cb) -> db.query q1, v1, cb
      (cb) -> db.query q2, v2, cb
    ], (err) ->
      console.log "Error querying: #{JSON.stringify(err)}" if err?