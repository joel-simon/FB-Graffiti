db = require '../adapters/db'
s3 = require '../adapters/s3'
images = require 'images'



module.exports = (req, res) ->
  {key, img} = req.body
  path = "#{key}.png"

  formatted = img.replace /^data:image\/\w+;base64,/, ""
  delta = images new Buffer(formatted, 'base64')
  start = new Date().getTime()
  console.log path
  s3.getImage { bucket: 'facebookGraffiti', path }, (err, data) ->
    options = { res, path, start, delta, data }
    if err then newImage options else existingImage options

newImage = ({res, path, start, delta}) ->
  console.log 'newImage', delta
  type = 'new'
  width = delta.width()
  height = delta.height()
  newImage = (delta).encode 'png'
  done { res, newImage, path, start, width, height, type }

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
    newImage = images(dWidth, dHeight).draw(oldImg,0,0).draw(delta,0,0).encode("png")
    height = dHeight
  else if (dHeight != oldHeight or dWidth != oldWidth)
    newImage = oldImg.draw(delta.size(oldWidth, oldHeight),0,0).encode("png")
  else
    newImage = oldImg.draw(delta,0,0).encode "png"
  done { res, newImage, path, start, width, height, type }

done = ({ res, newImage, path, start, width, height, type }) ->
  time = (new Date().getTime()) - start
  s3.putImage {bucket:'facebookGraffiti', img: newImage, path}, (err) ->
    if err?
      console.log "ERR:#{JSON.stringify(err)}"
      return res.send 400 
    res.send(path);
    query = 'INSERT INTO 
              events (time_taken, id, width, height, type)
            VALUES ($1,$2,$3,$4,$5)'
    values = [time, path.split('.')[0], width, height, type]
    db.query query, values, (err, result) ->
      if err?
        console.log "ERR:#{JSON.stringify(err)}"