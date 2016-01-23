db = require '../adapters/db'
s3 = require '../adapters/s3'
async = require 'async'

module.exports = (req, res) ->
  { user } = req.body
  console.log user
  res.send 400 unless user?
  
  q1 = "SELECT id FROM graffiti WHERE owner = $1"
  q2 = "DELETE FROM graffiti WHERE owner = $1;"
  q3 = "INSERT INTO users (id, optout) VALUES ($1, true);"

  db.query q1, [ user ], (err, result) ->
    if err?
      console.log err
      return res.send 400
    async.parallel [
      (cb) -> async.each result.rows, s3.deleteImg, cb
      (cb) -> db.query q2, [ user ], cb
      (cb) -> db.query q3, [ user ], cb
    ], (err) ->
      if err?
        console.log err
        return res.send 400
      res.send 200