db = require '../adapters/db'
AWS = require 'aws-sdk'
AWS.config.loadFromPath __dirname+'/../config.json'
s3 = new AWS.S3()

module.exports = (req, res) ->
  id = req.body.id
  params =
    Bucket: 'facebookGraffiti'
    Key: id+'.png'
  s3.deleteObject params, (err) ->
    return res.status(500).send('Err') if err?
    db.query "DELETE FROM graffiti WHERE id = $1::text", [id], (err) ->
      return res.status(500).send('Err') if err?
      console.log "Deleted #{id}."
      res.send 200
