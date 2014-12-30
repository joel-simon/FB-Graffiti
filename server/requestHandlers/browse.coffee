db = require '../adapters/db'
module.exports = (req, res) ->
  q = """
      select * from (
        SELECT MAX(events.post_time), graffiti.id, graffiti.url
        FROM events, graffiti
        WHERE
          graffiti.id = events.id AND
          graffiti.url IS NOT NULL
        GROUP BY graffiti.id
        ) as FOOO
      ORDER BY max desc limit 25

      """

  db.query q, [], (err, results) ->
    console.log err if err
    # console.log results.rows
    res.render 'browse.jade', { imgList: results.rows }