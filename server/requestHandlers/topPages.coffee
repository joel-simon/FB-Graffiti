db = require '../adapters/db'
async = require 'async'
moment = require 'moment'
request = require 'request'

memCache = {}

module.exports = (req, res) ->
  q = "SELECT 
        count(*) as count, graffiti.owner as id
      FROM events, graffiti
      WHERE
        events.id = graffiti.id
        AND events.post_time > (NOW() - INTERVAL '7 DAY')
        AND owner != ''
      GROUP BY graffiti.owner
      ORDER BY count desc
      LIMIT 10;"

  getFBInfo = ({ count, id }, cb) ->
    return cb null, memCache[id] if memCache[id]?
    fields = [ 'picture', 'name', 'link' ].join ','
    url = "https://graph.facebook.com/#{id}?fields=#{fields}"
    request { url, json: true }, (err, response, body) ->
      return cb err if err?
      memCache[id] = body
      cb null, body

  db.query q, [], (err, results) ->
    return res.send err if err
    async.map results.rows, getFBInfo, (err, pages) ->
      return res.send err if err
      res.render 'topPages.jade', { pages }