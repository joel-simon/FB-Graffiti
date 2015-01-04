db = require '../adapters/db'
moment = require 'moment'

module.exports = (req, res) ->
  { id, last } = req.query
  last = moment(last.replace(/_/g , ' ')).format()
  q = "select COUNT(*) from (
        SELECT DISTINCT(graffiti.id)
        FROM events, graffiti
        WHERE
          graffiti.id = events.id AND
          graffiti.owner LIKE $1 AND
          events.post_time > $2
        ) AS foo"
  db.query q, [ id, last ], (err, result) ->
    if err?
      res.send 400
    res.send 200, result.rows[0].count
    