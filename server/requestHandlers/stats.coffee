db = require '../adapters/db'
moment = require 'moment'
tz = require 'moment-timezone'
module.exports = (req, res) ->
  q = """
    SELECT COUNT(*) AS count
       , (extract('epoch' from post_time)::int / 3600) AS hour
       , AVG(time_taken)::int AS average
      FROM events
      
      group by hour
      order by hour desc
  """
  #, FROM (select * from events where date(post_time) = date(now())) as bar
  #WHERE type = 'new'
  db.query q, [], (err, results) ->
    console.log err if err?
    return res.send 400 if err?
    s = ''
    results.rows.forEach (r) ->
      day = moment(r.hour * 3600 * 1000).tz("Europe/Paris").format "YYYY MMMM Do ddd, hA"
      s += "#{day}   :   #{r.count}   :   #{r.average}<br>"
    res.send s