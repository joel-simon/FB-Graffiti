db = require '../adapters/db'
s3 = require '../adapters/s3'
images = require 'images'

module.exports = (req, res) ->
  { id, img } = req.body
  if !id or !img
    console.log 'Invalid setImage post params:', req.body
    return res.send 400

  path = "#{id}.png"
  console.log {path}

  formatted = img.replace /^data:image\/\w+;base64,/, ""
  delta = images new Buffer(formatted, 'base64')
  start = new Date().getTime()
  
  s3.getImage { bucket: 'facebookGraffiti', path }, (err, data) ->
    options = { res, path, start, delta, data }
    if err then newImage options else existingImage options

newImage = ({res, path, start, delta}) ->
  console.log 'newImage', delta
  type = 'new'
  width = delta.width()
  height = delta.height()
  img = (delta).encode 'png'
  done { res, img, path, start, width, height, type }

existingImage = ({res, path, start, delta, data}) ->
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
  done { res, img, path, start, width, height, type }

done = ({ res, img, path, start, width, height, type }) ->
  time = (new Date().getTime()) - start
  s3.putImage { bucket: 'facebookGraffiti', img, path }, (err) ->
    if err?
      console.log "ERR:#{JSON.stringify(err)}"
      return res.send 400 
    query = 'INSERT INTO 
              events (time_taken, id, width, height, type)
            VALUES ($1,$2,$3,$4,$5)'
    values = [time, path.split('.')[0], width, height, type]
    db.query query, values, (err, result) ->
      console.log "Error querying: #{JSON.stringify(err)}" if err?