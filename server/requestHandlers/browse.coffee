db = require '../adapters/db'
module.exports = (req, res) ->
  q = """
      SELECT distinct on (graffiti.id) graffiti.id, graffiti.url, events.post_time
      FROM events, graffiti
      WHERE 
        graffiti.id = events.id AND
        graffiti.url IS NOT NULL
      order by graffiti.id, post_time desc limit 25;
      """
  db.query q, [], (err, results) ->
    console.log err if err
    # console.log results.rows
    res.render 'browse.jade', { imgList: results.rows }