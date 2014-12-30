db = require '../adapters/db'
module.exports = (req, res) ->
  q = """
      SELECT distinct on (id_url.id) id_url.id, id_url.url, events.post_time
      FROM events, id_url
      WHERE 
        id_url.id = events.id AND
        id_url.url IS NOT NULL
      order by id_url.id, post_time desc limit 5;
      """
  db.query q, [], (err, results) ->
    console.log err if err
    # console.log results.rows
    res.render 'browse.jade', { imgList: results.rows }