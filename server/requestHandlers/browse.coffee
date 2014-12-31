db = require '../adapters/db'
moment = require 'moment'
module.exports = (req, res) ->
  user = req.query.u or '%'
  q = "select * from (
        SELECT MAX(events.post_time) as time, graffiti.id, graffiti.url
        FROM events, graffiti
        WHERE
          graffiti.id = events.id AND
          graffiti.url IS NOT NULL AND
          graffiti.owner LIKE $1
        GROUP BY graffiti.id
        ) as FOOO
      ORDER BY time desc limit 25"

  db.query q, [user], (err, results) ->
    console.log err if err
    if results.rows?.length
      results.rows.forEach (r) ->
        r.time = moment(r.time).fromNow()
    res.render 'browse.jade', { imgList: results.rows }