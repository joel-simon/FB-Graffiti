# db = require '../adapters/db'
# s3 = require '../adapters/s3'
# images = require ('images')
# module.exports = (req, res) ->
#   path = req.body.path+(+new Date())+'.png'
#   img = req.body.img
#   imgUrl = req.body.imgUrl
#   data = img.replace(/^data:image\/\w+;base64,/, "")
#   delta = images(new Buffer(data, 'base64'))
#   start = new Date().getTime()
#   width = delta.width()
#   height = delta.height()
#   newImage = (delta).encode("png")
  
#   putOptions = 
#     bucket: 'graffitiSnapshots'
#     image: newImage
#     path : path

#   s3.putImage putOptions, (err, data) ->
#     if err?
#       console.log 'Err putting:', err
#       res.send 404
#     else
#       res.send path
#       end = new Date().getTime()
#       time = end - start
#       query = 'INSERT INTO events
#         (time_taken, url, id, width, height, type)
#         values ($1,$2,$3,$4,$5,$6)'
#       values = [time,imgUrl, path, width, height, 'share']
#       db.query query, values, (err, result) ->
#         if err
#           console.log('ERR:'+err)