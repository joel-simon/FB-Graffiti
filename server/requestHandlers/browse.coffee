db = require '../adapters/db'
moment = require 'moment'
module.exports = (req, res) ->
  user = req.query.u # or '%'
  return res.send 400 unless user?
  n = parseInt(req.query.n) or 25
  k = parseInt(req.query.k) or 0
  q = "select * from (
        SELECT MAX(events.post_time) as time, graffiti.id, graffiti.url
        FROM events, graffiti
        WHERE
          graffiti.id = events.id AND
          graffiti.url IS NOT NULL AND
          graffiti.owner LIKE $1
        GROUP BY graffiti.id
        ) as FOOO
      ORDER BY time desc limit $2 offset $3"

  db.query q, [user, n, k], (err, results) ->
    console.log err if err
    if results.rows?.length
      results.rows.forEach (r) ->
        r.time = moment(r.time).fromNow()
    res.render 'browse.jade', { imgList: results.rows, user: user }