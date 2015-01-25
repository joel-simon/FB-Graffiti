db = require '../adapters/db'
moment = require 'moment'

module.exports = (req, res) ->
  { id } = req.body
  # console.log 'reported:', id
  res.send 400 unless id?
  q = "UPDATE graffiti set reported = false where id = $1"
  db.query q, [ id ], (err, result) ->
    if err?
      console.log 'err', err
      res.send 400
    res.send 200